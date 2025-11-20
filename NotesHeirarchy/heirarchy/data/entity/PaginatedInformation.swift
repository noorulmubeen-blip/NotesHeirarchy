//
//  PaginatedInformation.swift
//  NotesHeirarchy
//
//  Created by Noor ul Mubeen on 20/11/2025.
//

struct PaginatedData<T: Decodable>: Decodable {
    let pageNo: Int
    let totalItems: Int
    let pageSize: Int
    let totalPages: Int
    let data: [T]
}
