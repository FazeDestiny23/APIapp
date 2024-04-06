//
//  Configure.swift
//  APIapp
//
//  Created by FRANCISCO AQUINO on 05/04/24.
//

import Foundation
import SwiftKuery
import SwiftKueryPostgreSQL

struct DatabaseManager {
    static let shared = DatabaseManager()
    
    private let pool: ConnectionPool<PostgreSQLConnection>
    
    private init() {
        let connection = PostgreSQLConnection(
            host: Environment.dbHost,
            port: Environment.port,
            options: [.databaseName(Environment.db)],
            connectionProperties: [
                .username(Environment.dbUser),
                .password(Environment.dbPassword)
            ]
        )
        self.pool = ConnectionPool(options: connection)
    }
    
    func executeQuery(_ query: String) -> EventLoopFuture<PostgreSQLResult> {
        return self.pool.getConnection().flatMap { connection in
            let promise = connection.eventLoop.makePromise(of: PostgreSQLResult.self)
            connection.query(query) { result in
                promise.completeWith(result)
                connection.release()
            }
            return promise.futureResult
        }
    }
}
