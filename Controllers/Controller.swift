//
//  Controller.swift
//  APIapp
//
//  Created by FRANCISCO AQUINO on 05/04/24.
//

import Foundation

struct DatabaseManager {
    static let shared = DatabaseManager()

    private let eventLoopGroup: EventLoopGroup
    private let pool: EventLoopGroupConnectionPool<PostgresConnectionSource>

    private init() {
        self.eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        
        let configuration = PostgresConfiguration(
            unixDomainSocketPath: nil,
            address: .makeAddressResolvingHost(Environment.dbHost, port: Environment.port),
            credentials: .init(username: Environment.dbUser, password: Environment.dbPassword),
            database: Environment.db
        )

        self.pool = EventLoopGroupConnectionPool(
            source: PostgresConnectionSource(configuration: configuration, on: eventLoopGroup),
            maxConnectionsPerEventLoop: 1,
            on: eventLoopGroup
        )
    }

    func executeQuery(_ query: String, parameters: [PostgresData] = []) -> EventLoopFuture<PostgresQueryResult> {
        return self.pool.withConnection(logger: .init(label: "PostgresClient")) { connection in
            return connection.query(query, parameters: parameters)
        }
    }
}
