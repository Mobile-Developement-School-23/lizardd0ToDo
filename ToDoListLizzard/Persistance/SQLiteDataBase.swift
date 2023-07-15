//
//  OpenOrCreateDB.swift
//  ToDoListLizzard
//
//  Created by Елизавета Шерман on 11.07.2023.
//

import Foundation
import SQLite3

class SqliteError : Error {
    var message = ""
    var error = SQLITE_ERROR
    init(message: String = "") {
        self.message = message
    }
    init(error: Int32) {
        self.error = error
    }
}


class DataBase {
    let dbURL: URL
    var db: OpaquePointer?
    
    init() {
        do {
            do {
                dbURL = try FileManager.default
                    .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                    .appendingPathComponent("integration.db")
            } catch {
                dbURL = URL(fileURLWithPath: "")
                return
            }
            
            try openDB()
            createTables()
        } catch {
            return
        }
    }
    
    func openDB() throws {
        if sqlite3_open(dbURL.path, &db) != SQLITE_OK {
            throw SqliteError(message: "error opening database \(dbURL.absoluteString)")
        }
    }
    
    func createTables() {
        let createTableString = """
        CREATE TABLE IF NOT EXISTS Items(
        id CHAR(255) PRIMARY KEY NOT NULL,
        text CHAR(255),
        importance CHAR(255),
        deadline CHAR(255),
        flag CHAR(255),
        createdate CHAR(255),
        changedate CHAR(255));
        """
        var createTableStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) ==
            SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("\nItems table created.")
            } else {
                print("\nItems table is not created.")
            }
        } else {
            print("\nCREATE TABLE statement is not prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }  // создание таблицы
    
    
    
    //________________INSERTING DATA______________//
    func insert(item: String) {
        let insertStatementString = "INSERT OR REPLACE INTO Items (id, text, importance, deadline, flag, createdate, changedate) VALUES (?, ?, ?, ?, ?, ?, ?);"
        
        var insertStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) ==
            SQLITE_OK {
            
            let str = item.components(separatedBy: ",").map({$0 as NSString})
            sqlite3_bind_text(insertStatement, 1, str[0].utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, str[1].utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, str[2].utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, str[3].utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 5, str[4].utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 6, str[5].utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 7, str[6].utf8String, -1, nil)
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("\nSuccessfully inserted row.")
            } else {
                print("\nCould not insert row.")
            }
        } else {
            print("\nINSERT statement is not prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    
    
    
    //______________SELECTING DATA_______________//
    func query() -> String? {
        var sqlArray = [String]()
        let queryStatementString = "SELECT * FROM Items;"
        var queryStatement: OpaquePointer?
        if sqlite3_prepare_v2(
            db,
            queryStatementString,
            -1,
            &queryStatement,
            nil
        ) == SQLITE_OK {
            print("\n")
            while (sqlite3_step(queryStatement) == SQLITE_ROW) {
                var sqlItems = [String]()
                let id = String(cString: sqlite3_column_text(queryStatement, 0))
                sqlItems.append(id)
                let text = String(cString: sqlite3_column_text(queryStatement, 1))
                sqlItems.append(text)
                let importance = String(cString: sqlite3_column_text(queryStatement, 2))
                sqlItems.append(importance)
                var deadline:String
                guard let queryResultCol3 = sqlite3_column_text(queryStatement, 3) else {
                    print("Query result is nil.")
                    deadline = ""
                    return nil
                }
                deadline = String(cString: queryResultCol3)
                sqlItems.append(deadline)
                let flag = String(cString: sqlite3_column_text(queryStatement, 4))
                sqlItems.append(flag)
                let createdate = String(cString: sqlite3_column_text(queryStatement, 5))
                sqlItems.append(createdate)
                var changedate: String
                guard let queryResultCol6 = sqlite3_column_text(queryStatement, 6) else {
                    print("Query result is nil.")
                    changedate = ""
                    return nil
                }
                changedate = String(cString: queryResultCol6)
                sqlItems.append(changedate)
                
                let sqlRow = sqlItems.joined(separator: ",")
                sqlArray.append(sqlRow)
            }
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("\nQuery is not prepared \(errorMessage)")
        }
        sqlite3_finalize(queryStatement)
        return sqlArray.joined(separator: "\n")
    }
 
    
    //______________DELETING DATA________________//
    
    func delete(item: TodoItem) {
        let deleteStatementString = "DELETE FROM Items WHERE Id = \"\(item.id)\";"
        var deleteStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) ==
            SQLITE_OK {
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("\nSuccessfully deleted row.")
            } else {
                print("\nCould not delete row.")
            }
        } else {
            print("\nDELETE statement could not be prepared")
        }
        
        sqlite3_finalize(deleteStatement)
    }
    
    func deleteAllData() {
        let deleteStatementString = "DELETE FROM Items;"
        var deleteStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) ==
            SQLITE_OK {
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("\nSuccessfully deleted rows.")
            } else {
                print("\nCould not delete rows.")
            }
        } else {
            print("\nDELETE statement could not be prepared")
        }
        
        sqlite3_finalize(deleteStatement)
    }
    
}
