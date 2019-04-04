//
//  PostMetadataDataSource.swift
//  Blog Nerd Ranch
//
//  Created by Chris Downie on 9/3/18.
//  Copyright © 2018 Chris Downie. All rights reserved.
//

import Foundation

/// Group & sort posts based on the given ordering.
struct PostMetadataDataSource {
    /// Represents a named group of posts. The nature of the group depends on the ordering it was created with
    private struct Group {
        let name : String?
        var postMetadata: [PostMetadata]
    }
    
    var ordering : DisplayOrdering {
        didSet {
            createGroups()
        }
    }
    var postMetadataList : [PostMetadata] {
        didSet {
            createGroups()
        }
    }
    
    private var groups: [Group] = []
    
    init(ordering: DisplayOrdering, postMetadata: [PostMetadata] = []) {
        self.ordering = ordering
        self.postMetadataList = postMetadata
        createGroups()
    }
    
    private mutating func createGroups() {
        groups = getGroups()
    }
    
    // MARK: UICollectionViewDataSource convenience
    
    func numberOfSections() -> Int {
        return groups.count
    }
    
    func titleForSection(_ section: Int) -> String? {
        return groups[section].name
    }
    
    func numberOfPostsInSection(_ section: Int) -> Int {
        return groups[section].postMetadata.count
    }
    
    func postMetadata(at indexPath: IndexPath) -> PostMetadata {
        return groups[indexPath.section].postMetadata[indexPath.row]
    }
 
    // MARK: Grouping
    
    private func getGroups() -> [Group] {
        switch ordering.grouping {
        case .none:
            let filteredArray = sortDataArray(filteredArray: postMetadataList)
            return [Group(name: nil, postMetadata: filteredArray)]
            
        case .author:
            return getAuthorGroups()
            
        case .month:
            return getMonthGroups()
        }
    }
    
    private func getAuthorGroups() -> [Group] {
        var groups = [Group]()
        
        // Create array of names in postMetadata and then an array of unique names
        let names = postMetadataList.map { $0.author["name"] }
        let uniqueNameSet = Array(Set(names))
        
        for name in uniqueNameSet {
            var filteredArray = postMetadataList.filter { $0.author["name"] == name }
            
            // After we have the data for the group, go ahead and sort it
            filteredArray = sortDataArray(filteredArray: filteredArray)
            
            // Create group with sorted filter and unique author name for the group name
            let group = Group(name: name, postMetadata: filteredArray)
            groups.append(group)
        }
    
        return groups
    }
    
    private func getMonthGroups() -> [Group] {
        var groups = [Group]()
        
        // Set up dateFormatter to show only months
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        
        // Create array of off months in postMetadata, and then an array of unique months
        let months = postMetadataList.map { dateFormatter.string(from: $0.publishDate) }
        let uniqueMonthSet = Array(Set(months))
        
        for month in uniqueMonthSet {
            var filteredArray = postMetadataList.filter { dateFormatter.string(from: $0.publishDate) == month }
            
            // After we have the data for the group, go ahead and sort it
            filteredArray = sortDataArray(filteredArray: filteredArray)
            
            // Create group with sorted filter and unique month for the name
            let group = Group(name: month, postMetadata: filteredArray)
            groups.append(group)
        }
        
        return groups
    }

    // MARK: Sorting
    
    private func sortDataArray(filteredArray: [PostMetadata]) -> [PostMetadata] {
        switch ordering.sorting {
        case .alphabeticalByAuthor(ascending: true):
            return filteredArray.sorted(by: { $0.author["name"]! < $1.author["name"]! })
            
        case .alphabeticalByAuthor(ascending: false):
            return filteredArray.sorted(by: { $0.author["name"]! > $1.author["name"]! })
            
        case .alphabeticalByTitle(ascending: true):
            return filteredArray.sorted(by: { $0.title < $1.title })
            
        case .alphabeticalByTitle(ascending: false):
            return filteredArray.sorted(by: { $0.title > $1.title })
            
        case .byPublishDate(recentFirst: true):
            return filteredArray.sorted(by: { $0.publishDate.compare($1.publishDate) == .orderedDescending })
            
        case .byPublishDate(recentFirst: false):
            return filteredArray.sorted(by: { $0.publishDate.compare($1.publishDate) == .orderedAscending })
        }
    }
    
}
