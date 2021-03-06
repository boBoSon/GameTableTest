/// Types that adopt TableMapping declare a particular relationship with
/// a database table.
///
/// Types that adopt both TableMapping and RowConvertible are granted with
/// built-in methods that allow to fetch instances identified by key:
///
///     try Person.fetchOne(db, key: 123)  // Person?
///     try Citizenship.fetchOne(db, key: ["personId": 12, "countryId": 45]) // Citizenship?
///
/// TableMapping is adopted by Record.
public protocol TableMapping {
    /// The name of the database table
    static var databaseTableName: String { get }
    
    /// This flag tells whether the hidden "rowid" column should be fetched
    /// with other columns.
    ///
    /// Its default value is false:
    ///
    ///     // SELECT * FROM persons
    ///     try Person.fetchAll(db)
    ///
    /// When true, the rowid column is fetched:
    ///
    ///     // SELECT *, rowid FROM persons
    ///     try Person.fetchAll(db)
    static var selectsRowID: Bool { get }
}

extension TableMapping {
    /// Default value: false.
    public static var selectsRowID: Bool { return false }
}

extension TableMapping {
    
    // MARK: Counting All
    
    /// The number of records.
    ///
    /// - parameter db: A database connection.
    public static func fetchCount(_ db: Database) throws -> Int {
        return try all().fetchCount(db)
    }
}

extension TableMapping {
    
    // MARK: Key Requests
    
    static func filter<Sequence: Swift.Sequence>(_ db: Database, keys: Sequence) throws -> QueryInterfaceRequest<Self> where Sequence.Iterator.Element: DatabaseValueConvertible {
        let primaryKey = try db.primaryKey(databaseTableName)
        let columns = primaryKey?.columns.map { Column($0) } ?? [Column.rowID]
        GRDBPrecondition(columns.count == 1, "table \(databaseTableName) has multiple columns in its primary key")
        let column = columns[0]
        
        let keys = Array(keys)
        switch keys.count {
        case 0:
            return none()
        case 1:
            return filter(column == keys[0])
        default:
            return filter(keys.contains(column))
        }
    }
    
    // Raises a fatal error if there is no unique index on the columns (unless
    // fatalErrorOnMissingUniqueIndex is false, for testability).
    //
    // TODO: think about
    // - allowing non unique keys in Type.fetchOne(db, key: ...) ???
    // - allowing non unique keys in Type.fetchAll/Cursor(db, keys: ...)
    // - forbidding Player.deleteOne(db, key: ["email": nil]) since this may delete several rows (case of a nullable unique key)
    static func filter(_ db: Database, keys: [[String: DatabaseValueConvertible?]], fatalErrorOnMissingUniqueIndex: Bool = true) throws -> QueryInterfaceRequest<Self> {
        // SELECT * FROM table WHERE ((a=? AND b=?) OR (c=? AND d=?) OR ...)
        let keyPredicates: [SQLExpression] = try keys.map { key in
            // Prevent filter(db, keys: [[:]])
            GRDBPrecondition(!key.isEmpty, "Invalid empty key dictionary")

            // Prevent filter(db, keys: [["foo": 1, "bar": 2]]) where
            // ("foo", "bar") is not a unique key (primary key or columns of a
            // unique index)
            guard let orderedColumns = try db.columnsForUniqueKey(key.keys, in: databaseTableName) else {
                let message = "table \(databaseTableName) has no unique index on column(s) \(key.keys.sorted().joined(separator: ", "))"
                if fatalErrorOnMissingUniqueIndex {
                    fatalError(message)
                } else {
                    throw DatabaseError(resultCode: .SQLITE_MISUSE, message: message)
                }
            }
            
            let lowercaseOrderedColumns = orderedColumns.map { $0.lowercased() }
            let columnPredicates: [SQLExpression] = key
                // Sort key columns in the same order as the unique index
                .sorted { (kv1, kv2) in lowercaseOrderedColumns.index(of: kv1.0.lowercased())! < lowercaseOrderedColumns.index(of: kv2.0.lowercased())! }
                .map { (column, value) in Column(column) == value }
            return SQLBinaryOperator.and.join(columnPredicates)! // not nil because columnPredicates is not empty
        }
        
        guard let predicate = SQLBinaryOperator.or.join(keyPredicates) else {
            // No key
            return none()
        }
        
        return filter(predicate)
    }
}

extension TableMapping {
    
    // MARK: Deleting All
    
    /// Deletes all records; returns the number of deleted rows.
    ///
    /// - parameter db: A database connection.
    /// - returns: The number of deleted rows
    /// - throws: A DatabaseError is thrown whenever an SQLite error occurs.
    @discardableResult
    public static func deleteAll(_ db: Database) throws -> Int {
        return try all().deleteAll(db)
    }
}

extension TableMapping {
    
    // MARK: Deleting by Single-Column Primary Key
    
    /// Delete records identified by their primary keys; returns the number of
    /// deleted rows.
    ///
    ///     try Person.deleteAll(db, keys: [1, 2, 3])
    ///
    /// - parameters:
    ///     - db: A database connection.
    ///     - keys: A sequence of primary keys.
    /// - returns: The number of deleted rows
    @discardableResult
    public static func deleteAll<Sequence: Swift.Sequence>(_ db: Database, keys: Sequence) throws -> Int where Sequence.Iterator.Element: DatabaseValueConvertible {
        let keys = Array(keys)
        if keys.isEmpty {
            // Avoid hitting the database
            return 0
        }
        return try filter(db, keys: keys).deleteAll(db)
    }
    
    /// Delete a record, identified by its primary key; returns whether a
    /// database row was deleted.
    ///
    ///     try Person.deleteOne(db, key: 123)
    ///
    /// - parameters:
    ///     - db: A database connection.
    ///     - key: A primary key value.
    /// - returns: Whether a database row was deleted.
    @discardableResult
    public static func deleteOne<PrimaryKeyType: DatabaseValueConvertible>(_ db: Database, key: PrimaryKeyType?) throws -> Bool {
        guard let key = key else {
            // Avoid hitting the database
            return false
        }
        return try deleteAll(db, keys: [key]) > 0
    }
}

extension TableMapping {

    // MARK: Deleting by Key
    
    /// Delete records identified by the provided unique keys (primary key or
    /// any key with a unique index on it); returns the number of deleted rows.
    ///
    ///     try Person.deleteAll(db, keys: [["email": "a@example.com"], ["email": "b@example.com"]])
    ///
    /// - parameters:
    ///     - db: A database connection.
    ///     - keys: An array of key dictionaries.
    /// - returns: The number of deleted rows
    @discardableResult
    public static func deleteAll(_ db: Database, keys: [[String: DatabaseValueConvertible?]]) throws -> Int {
        if keys.isEmpty {
            // Avoid hitting the database
            return 0
        }
        return try filter(db, keys: keys).deleteAll(db)
    }
    
    /// Delete a record, identified by a unique key (the primary key or any key
    /// with a unique index on it); returns whether a database row was deleted.
    ///
    ///     Person.deleteOne(db, key: ["name": Arthur"])
    ///
    /// - parameters:
    ///     - db: A database connection.
    ///     - key: A dictionary of values.
    /// - returns: Whether a database row was deleted.
    @discardableResult
    public static func deleteOne(_ db: Database, key: [String: DatabaseValueConvertible?]) throws -> Bool {
        return try deleteAll(db, keys: [key]) > 0
    }
}

extension TableMapping {
    /// Returns a function that returns the primary key of a row.
    ///
    /// If the table has no primary key, and selectsRowID is true, the primary
    /// key is the "rowid" column.
    ///
    ///     try dbQueue.inDatabase { db in
    ///         let primaryKey = try Person.rowPrimaryKey(db)
    ///         let row = try Row.fetchOne(db, "SELECT * FROM persons")!
    ///         primaryKey(row) // ["id": 1]
    ///     }
    ///
    /// - throws: A DatabaseError if table does not exist.
    static func rowPrimaryKey(_ db: Database) throws -> (Row) -> [String: DatabaseValue] {
        if let primaryKey = try db.primaryKey(databaseTableName) {
            let columns = primaryKey.columns
            return { row in Dictionary(keys: columns) { row.value(named: $0) } }
        } else if selectsRowID {
            return { row in [Column.rowID.name: row.value(Column.rowID)] }
        } else {
            return { _ in [:] }
        }
    }
    
    /// Returns a function that returns true if and only if two rows have the
    /// same primary key and both primary keys contain at least one non-null
    /// value.
    ///
    ///     try dbQueue.inDatabase { db in
    ///         let comparator = try Person.primaryKeyRowComparator(db)
    ///         let row0 = Row(["id": nil, "name": "Unsaved"])
    ///         let row1 = Row(["id": 1, "name": "Arthur"])
    ///         let row2 = Row(["id": 1, "name": "Arthur"])
    ///         let row3 = Row(["id": 2, "name": "Barbara"])
    ///         comparator(row0, row0) // false
    ///         comparator(row1, row2) // true
    ///         comparator(row1, row3) // false
    ///     }
    ///
    /// - throws: A DatabaseError if table does not exist.
    /// - attention: This method is deprecated. It will be removed is the next
    ///   major version of the library, without any replacement. 
    @available(*, deprecated)
    public static func primaryKeyRowComparator(_ db: Database) throws -> (Row, Row) -> Bool {
        let primaryKey = try rowPrimaryKey(db)
        return { (lhs, rhs) in
            let (lhs, rhs) = (primaryKey(lhs), primaryKey(rhs))
            guard lhs.contains(where: { !$1.isNull }) else { return false }
            guard rhs.contains(where: { !$1.isNull }) else { return false }
            return lhs == rhs
        }
    }
}
