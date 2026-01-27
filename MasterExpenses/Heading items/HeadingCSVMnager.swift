//
//  HeadingCSVMnager.swift
//  MasterExpenses
//
//  Created by Brian Quick on 2026-01-25.
//

import Foundation

struct HeadingCSVManager {
    private static let filename = "headings"
    
    /// Load [Heading] from iCloud MyFinances/headings.csv
    static func loadHeadings() -> [Heading] {
        let fileManager = FileManager.default
        
        guard let containerURL = fileManager.url(forUbiquityContainerIdentifier: nil) else {
            print("iCloud container unavailable")
            return []
        }
        
        let myFinancesDir = containerURL.appendingPathComponent("MyFinances")
        let fileURL = myFinancesDir.appendingPathComponent(filename).appendingPathExtension("csv")
        print("directory for file \(fileURL.path)")
        // Create directory if needed (iCloud requirement)
        do {
            try fileManager.createDirectory(at: myFinancesDir,
                                          withIntermediateDirectories: true,
                                          attributes: nil)
        } catch {
            print("Directory setup: \(error.localizedDescription)")
        }
        
        // Use NSFileCoordinator for iCloud access
        let coordinator = NSFileCoordinator()
        var headings: [Heading] = []
        var coordError: NSError?
        
        coordinator.coordinate(readingItemAt: fileURL, options: [], error: &coordError) { url in
            do {
                let data = try Data(contentsOf: url)
                let csvString = String( data: data, encoding: .utf8) ?? ""
                headings = parseCSVHeadings(csvString)
                print("Loaded \(headings.count) headings from iCloud")
            } catch {
                print("CSV read error: \(error.localizedDescription)")
            }
        }
        
        if let error = coordError {
            print("iCloud coordination error: \(error.localizedDescription)")
        }
        
        return headings
    }
    
    /// Save [Heading] to iCloud MyFinances/headings.csv
    static func saveHeadings(_ headings: [Heading]) throws {
        let fileManager = FileManager.default
        
        guard let containerURL = fileManager.url(forUbiquityContainerIdentifier: nil) else {
            throw NSError(domain: "iCloud", code: 1, userInfo: [NSLocalizedDescriptionKey: "iCloud unavailable"])
        }
        
        let myFinancesDir = containerURL.appendingPathComponent("MyFinances")
        let fileURL = myFinancesDir.appendingPathComponent(filename).appendingPathExtension("csv")
        
        // Create directory
        try fileManager.createDirectory(at: myFinancesDir,
                                      withIntermediateDirectories: true,
                                      attributes: nil)
        
        let csvString = encodeCSVHeadings(headings)
        let coordinator = NSFileCoordinator()
        var coordError: NSError?
        
        coordinator.coordinate(writingItemAt: fileURL, options: [.forReplacing], error: &coordError) { url in
            do {
                try csvString.write(to: url, atomically: true, encoding: .utf8)
                print("Saved \(headings.count) headings to iCloud: \(fileURL.path)")
            } catch {
                print("CSV write error: \(error.localizedDescription)")
            }
        }
        
        if let error = coordError {
            throw error
        }
    }
    
    // MARK: - CSV Parsing
    private static func parseCSVHeadings(_ csvString: String) -> [Heading] {
        let lines = csvString.components(separatedBy: .newlines).filter { !$0.isEmpty }
        var headings: [Heading] = []
        
        for line in lines.dropFirst() {  // Skip header
            let columns = line.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }
            guard columns.count >= 3,
                  let name = columns.first,
                  let expenseStr = columns.dropFirst().first,
                  let expense = Bool(expenseStr),
                  let trackingStr = columns.dropFirst(2).first,
                  let tracking = Bool(trackingStr) else { continue }
            
            let heading = Heading(name: name, expense: expense, tracking: tracking)
            headings.append(heading)
        }
        
        return headings
    }
    
    // MARK: - CSV Encoding
    private static func encodeCSVHeadings(_ headings: [Heading]) -> String {
        var csv = "name,expense,tracking\n"
        for heading in headings {
            let line = "\(escapeCSV(heading.name)),\(heading.expense),\(heading.tracking)\n"
            csv += line
        }
        return csv
    }
    
    private static func escapeCSV(_ value: String) -> String {
        let needsQuotes = value.contains(",") || value.contains("\"") || value.contains("\n")
        let escaped = needsQuotes ? value.replacingOccurrences(of: "\"", with: "\"\"") : value
        return needsQuotes ? "\"\(escaped)\"" : escaped
    }
}
