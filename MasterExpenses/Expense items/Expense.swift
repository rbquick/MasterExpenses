import SwiftUI

struct Expense: Codable, Identifiable {
    let name: String
    let year: Int
    let jan: Double
    let feb: Double
    let mar: Double
    let apr: Double
    let may: Double
    let jun: Double
    let jul: Double
    let aug: Double
    let sep: Double
    let oct: Double
    let nov: Double
    let dec: Double
    let total: Double
    let average: Double
    
    // Identifiable conformance - unique ID based on name + year
    var id: String {
        "\(name)-\(year)"
    }
    
    enum CodingKeys: String, CodingKey {
        case name, year, jan, feb, mar, apr, may, jun, jul, aug, sep, oct, nov, dec, total, average
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        year = try container.decode(Int.self, forKey: .year)
        
        // Decode optional doubles with 0.00 default
        jan = try container.decodeIfPresent(Double.self, forKey: .jan) ?? 0.00
        feb = try container.decodeIfPresent(Double.self, forKey: .feb) ?? 0.00
        mar = try container.decodeIfPresent(Double.self, forKey: .mar) ?? 0.00
        apr = try container.decodeIfPresent(Double.self, forKey: .apr) ?? 0.00
        may = try container.decodeIfPresent(Double.self, forKey: .may) ?? 0.00
        jun = try container.decodeIfPresent(Double.self, forKey: .jun) ?? 0.00
        jul = try container.decodeIfPresent(Double.self, forKey: .jul) ?? 0.00
        aug = try container.decodeIfPresent(Double.self, forKey: .aug) ?? 0.00
        sep = try container.decodeIfPresent(Double.self, forKey: .sep) ?? 0.00
        oct = try container.decodeIfPresent(Double.self, forKey: .oct) ?? 0.00
        nov = try container.decodeIfPresent(Double.self, forKey: .nov) ?? 0.00
        dec = try container.decodeIfPresent(Double.self, forKey: .dec) ?? 0.00
        total = try container.decodeIfPresent(Double.self, forKey: .total) ?? 0.00
        average = try container.decodeIfPresent(Double.self, forKey: .average) ?? 0.00
    }
}

/// Loads expenses from a CSV file in the main bundle by filename.
func loadExpenses(from csvFileName: String) -> [Expense] {
    guard let fileURL = Bundle.main.url(forResource: csvFileName, withExtension: "csv") else {
        print("CSV file \(csvFileName) not found in bundle")
        return []
    }
    guard let data = try? Data(contentsOf: fileURL) else {
        print("Could not load data from file at \(fileURL.path)")
        return []
    }
    guard let csvString = String(data: data, encoding: .utf8) else {
        print("Could not decode data as UTF-8 string from file at \(fileURL.path)")
        return []
    }
    return parseCSV(csvString: csvString)
}

// CSV Parser (handles comma-separated with empty field support)
func parseCSV(csvString: String) -> [Expense] {
    let rows = csvString.components(separatedBy: .newlines)
        .filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
    
    guard !rows.isEmpty else { return [] }
    
    // Skip header row
    let dataRows = Array(rows.dropFirst())
    
    var expenses: [Expense] = []
    
    for row in dataRows {
        let fields = parseCSVRow(row)
        
        guard fields.count >= 2,
              let year = Int(fields[1]) else { continue }
        
        let expenseData: [String: Any] = [
            "name": fields[0],
            "year": year,
            "jan": Double(fields.count > 2 ? fields[2] : "") ?? 0.0,
            "feb": Double(fields.count > 3 ? fields[3] : "") ?? 0.0,
            "mar": Double(fields.count > 4 ? fields[4] : "") ?? 0.0,
            "apr": Double(fields.count > 5 ? fields[5] : "") ?? 0.0,
            "may": Double(fields.count > 6 ? fields[6] : "") ?? 0.0,
            "jun": Double(fields.count > 7 ? fields[7] : "") ?? 0.0,
            "jul": Double(fields.count > 8 ? fields[8] : "") ?? 0.0,
            "aug": Double(fields.count > 9 ? fields[9] : "") ?? 0.0,
            "sep": Double(fields.count > 10 ? fields[10] : "") ?? 0.0,
            "oct": Double(fields.count > 11 ? fields[11] : "") ?? 0.0,
            "nov": Double(fields.count > 12 ? fields[12] : "") ?? 0.0,
            "dec": Double(fields.count > 13 ? fields[13] : "") ?? 0.0,
            "total": Double(fields.count > 14 ? fields[14] : "") ?? 0.0,
            "average": Double(fields.count > 15 ? fields[15] : "") ?? 0.0
        ]
        
        do {
            if let jsonData = try? JSONSerialization.data(withJSONObject: expenseData),
               let expense = try? JSONDecoder().decode(Expense.self, from: jsonData) {
                expenses.append(expense)
            }
        } catch {
            print("Failed to decode row: \(row)")
        }
    }
    
    return expenses
}

// Simple CSV row parser (handles basic comma separation)
func parseCSVRow(_ row: String) -> [String] {
    var fields: [String] = []
    var currentField = ""
    var inQuotes = false
    
    for char in row {
        if char == "\"" {
            inQuotes.toggle()
        } else if char == "," && !inQuotes {
            fields.append(currentField)
            currentField = ""
        } else {
            currentField.append(char)
        }
    }
    fields.append(currentField)
    
    return fields.map { $0.trimmingCharacters(in: CharacterSet(charactersIn: "\"")) }
}

