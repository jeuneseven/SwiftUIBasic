//
//  FileManager.swift
//  SwiftUIBasic
//
//  File system operations, reading/writing files, and document directory
//

import SwiftUI

// MARK: - Basic Read/Write

struct BasicFileManagerExample: View {
    @State private var text = ""
    @State private var savedText = ""
    @State private var message = ""
    
    private let fileName = "notes.txt"
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Basic File Read/Write")
                .font(.headline)
            
            TextField("Enter text", text: $text)
                .textFieldStyle(.roundedBorder)
            
            HStack {
                Button("Save") {
                    saveFile()
                }
                
                Button("Load") {
                    loadFile()
                }
                
                Button("Delete") {
                    deleteFile()
                }
                .foregroundStyle(.red)
            }
            .buttonStyle(.borderedProminent)
            
            if !savedText.isEmpty {
                Text("Loaded: \(savedText)")
                    .padding()
                    .background(.gray.opacity(0.1))
                    .clipShape(.rect(cornerRadius: 8))
            }
            
            Text(message)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
    }
    
    private var fileURL: URL {
        URL.documentsDirectory.appending(path: fileName)
    }
    
    private func saveFile() {
        let data = Data(text.utf8)
        
        do {
            // .atomic: Write to temp file first, then rename
            // .completeFileProtection: Encrypt when device is locked
            try data.write(to: fileURL, options: [.atomic, .completeFileProtection])
            message = "Saved to: \(fileURL.lastPathComponent)"
        } catch {
            message = "Save failed: \(error.localizedDescription)"
        }
    }
    
    private func loadFile() {
        do {
            savedText = try String(contentsOf: fileURL, encoding: .utf8)
            message = "Loaded successfully"
        } catch {
            message = "Load failed: \(error.localizedDescription)"
        }
    }
    
    private func deleteFile() {
        do {
            try FileManager.default.removeItem(at: fileURL)
            savedText = ""
            message = "File deleted"
        } catch {
            message = "Delete failed: \(error.localizedDescription)"
        }
    }
}

// MARK: - Directory Locations

struct DirectoryLocationsExample: View {
    @State private var output = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Directory Locations")
                .font(.headline)
            
            Button("Show Directories") {
                showDirectories()
            }
            .buttonStyle(.borderedProminent)
            
            ScrollView {
                Text(output)
                    .font(.system(.caption, design: .monospaced))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
            .background(.gray.opacity(0.1))
            .clipShape(.rect(cornerRadius: 8))
        }
        .padding()
    }
    
    private func showDirectories() {
        var results: [String] = []
        
        // Documents Directory - User data, backed up
        let documents = URL.documentsDirectory
        results.append("Documents:\n\(documents.path())\n")
        
        // Caches Directory - Temporary data, not backed up
        let caches = URL.cachesDirectory
        results.append("Caches:\n\(caches.path())\n")
        
        // Temporary Directory - System may delete
        let temp = URL.temporaryDirectory
        results.append("Temporary:\n\(temp.path())\n")
        
        // Application Support - App data, backed up
        let appSupport = URL.applicationSupportDirectory
        results.append("App Support:\n\(appSupport.path())\n")
        
        // Home Directory
        let home = URL.homeDirectory
        results.append("Home:\n\(home.path())")
        
        output = results.joined(separator: "\n")
    }
}

// MARK: - Save/Load Codable Objects

struct Note: Codable, Identifiable {
    var id = UUID()
    var title: String
    var content: String
    var createdAt: Date
}

struct CodableFileExample: View {
    @State private var notes: [Note] = []
    @State private var newTitle = ""
    @State private var newContent = ""
    
    private let fileName = "notes.json"
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section("New Note") {
                        TextField("Title", text: $newTitle)
                        TextField("Content", text: $newContent)
                        
                        Button("Add Note") {
                            addNote()
                        }
                        .disabled(newTitle.isEmpty)
                    }
                }
                .frame(height: 200)
                
                List {
                    ForEach(notes) { note in
                        VStack(alignment: .leading) {
                            Text(note.title)
                                .font(.headline)
                            Text(note.content)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .onDelete(perform: deleteNotes)
                }
            }
            .navigationTitle("Notes (\(notes.count))")
            .toolbar {
                Button("Save") {
                    saveNotes()
                }
            }
            .onAppear {
                loadNotes()
            }
        }
    }
    
    private var fileURL: URL {
        URL.documentsDirectory.appending(path: fileName)
    }
    
    private func addNote() {
        let note = Note(title: newTitle, content: newContent, createdAt: .now)
        notes.append(note)
        newTitle = ""
        newContent = ""
        saveNotes()
    }
    
    private func deleteNotes(at offsets: IndexSet) {
        notes.remove(atOffsets: offsets)
        saveNotes()
    }
    
    private func saveNotes() {
        do {
            let data = try JSONEncoder().encode(notes)
            try data.write(to: fileURL, options: [.atomic])
        } catch {
            print("Save failed: \(error)")
        }
    }
    
    private func loadNotes() {
        guard FileManager.default.fileExists(atPath: fileURL.path()) else {
            return
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            notes = try JSONDecoder().decode([Note].self, from: data)
        } catch {
            print("Load failed: \(error)")
        }
    }
}

// MARK: - List Directory Contents

struct ListDirectoryExample: View {
    @State private var files: [String] = []
    @State private var message = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Documents Directory Contents")
                .font(.headline)
            
            HStack {
                Button("Refresh") {
                    listFiles()
                }
                
                Button("Create Test File") {
                    createTestFile()
                }
            }
            .buttonStyle(.borderedProminent)
            
            List(files, id: \.self) { file in
                HStack {
                    Image(systemName: file.hasSuffix("/") ? "folder" : "doc")
                    Text(file)
                }
            }
            
            Text(message)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .onAppear {
            listFiles()
        }
    }
    
    private func listFiles() {
        let documentsURL = URL.documentsDirectory
        
        do {
            let contents = try FileManager.default.contentsOfDirectory(
                at: documentsURL,
                includingPropertiesForKeys: [.isDirectoryKey],
                options: [.skipsHiddenFiles]
            )
            
            files = contents.map { url in
                var isDirectory: ObjCBool = false
                FileManager.default.fileExists(atPath: url.path(), isDirectory: &isDirectory)
                return url.lastPathComponent + (isDirectory.boolValue ? "/" : "")
            }.sorted()
            
            message = "Found \(files.count) items"
        } catch {
            message = "Error: \(error.localizedDescription)"
        }
    }
    
    private func createTestFile() {
        let url = URL.documentsDirectory.appending(path: "test_\(Date.now.timeIntervalSince1970).txt")
        try? "Test content".write(to: url, atomically: true, encoding: .utf8)
        listFiles()
    }
}

// MARK: - Create Subdirectory

struct CreateDirectoryExample: View {
    @State private var directoryName = ""
    @State private var message = ""
    @State private var directories: [String] = []
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Create Subdirectory")
                .font(.headline)
            
            HStack {
                TextField("Directory name", text: $directoryName)
                    .textFieldStyle(.roundedBorder)
                
                Button("Create") {
                    createDirectory()
                }
                .buttonStyle(.borderedProminent)
                .disabled(directoryName.isEmpty)
            }
            
            List(directories, id: \.self) { dir in
                HStack {
                    Image(systemName: "folder.fill")
                        .foregroundStyle(.blue)
                    Text(dir)
                }
            }
            
            Text(message)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .onAppear {
            listDirectories()
        }
    }
    
    private func createDirectory() {
        let url = URL.documentsDirectory.appending(path: directoryName)
        
        do {
            try FileManager.default.createDirectory(
                at: url,
                withIntermediateDirectories: true,
                attributes: nil
            )
            message = "Created: \(directoryName)"
            directoryName = ""
            listDirectories()
        } catch {
            message = "Error: \(error.localizedDescription)"
        }
    }
    
    private func listDirectories() {
        let documentsURL = URL.documentsDirectory
        
        do {
            let contents = try FileManager.default.contentsOfDirectory(
                at: documentsURL,
                includingPropertiesForKeys: [.isDirectoryKey],
                options: [.skipsHiddenFiles]
            )
            
            directories = contents.compactMap { url in
                var isDirectory: ObjCBool = false
                FileManager.default.fileExists(atPath: url.path(), isDirectory: &isDirectory)
                return isDirectory.boolValue ? url.lastPathComponent : nil
            }.sorted()
        } catch {
            message = "Error: \(error.localizedDescription)"
        }
    }
}

// MARK: - File Attributes

struct FileAttributesExample: View {
    @State private var output = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("File Attributes")
                .font(.headline)
            
            Button("Create & Inspect File") {
                createAndInspect()
            }
            .buttonStyle(.borderedProminent)
            
            ScrollView {
                Text(output)
                    .font(.system(.caption, design: .monospaced))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
            .background(.gray.opacity(0.1))
            .clipShape(.rect(cornerRadius: 8))
        }
        .padding()
    }
    
    private func createAndInspect() {
        let url = URL.documentsDirectory.appending(path: "attributes_test.txt")
        let content = "Hello, this is a test file for attributes."
        
        do {
            try content.write(to: url, atomically: true, encoding: .utf8)
            
            let attributes = try FileManager.default.attributesOfItem(atPath: url.path())
            
            var results: [String] = []
            
            if let size = attributes[.size] as? Int {
                results.append("Size: \(size) bytes")
            }
            
            if let created = attributes[.creationDate] as? Date {
                results.append("Created: \(created.formatted())")
            }
            
            if let modified = attributes[.modificationDate] as? Date {
                results.append("Modified: \(modified.formatted())")
            }
            
            if let type = attributes[.type] as? FileAttributeType {
                results.append("Type: \(type == .typeRegular ? "Regular File" : "Other")")
            }
            
            if let protection = attributes[.protectionKey] as? FileProtectionType {
                results.append("Protection: \(protection.rawValue)")
            }
            
            output = results.joined(separator: "\n")
        } catch {
            output = "Error: \(error.localizedDescription)"
        }
    }
}

// MARK: - FileManager Extension

extension FileManager {
    /// Write data to documents directory
    @discardableResult
    func writeToDocuments(
        _ data: Data,
        fileName: String,
        options: Data.WritingOptions = [.atomic, .completeFileProtection]
    ) throws -> URL {
        let url = URL.documentsDirectory.appending(path: fileName)
        try data.write(to: url, options: options)
        return url
    }
    
    /// Read string from documents directory
    func readFromDocuments(
        fileName: String,
        encoding: String.Encoding = .utf8
    ) throws -> String {
        let url = URL.documentsDirectory.appending(path: fileName)
        return try String(contentsOf: url, encoding: encoding)
    }
    
    /// Check if file exists in documents directory
    func existsInDocuments(fileName: String) -> Bool {
        let url = URL.documentsDirectory.appending(path: fileName)
        return fileExists(atPath: url.path())
    }
    
    /// Delete file from documents directory
    func deleteFromDocuments(fileName: String) throws {
        let url = URL.documentsDirectory.appending(path: fileName)
        try removeItem(at: url)
    }
    
    /// Get size of file in documents directory
    func sizeOfFile(at url: URL) -> Int? {
        let attributes = try? attributesOfItem(atPath: url.path())
        return attributes?[.size] as? Int
    }
}

struct FileManagerExtensionExample: View {
    @State private var output = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("FileManager Extension")
                .font(.headline)
            
            Button("Test Extension Methods") {
                testExtension()
            }
            .buttonStyle(.borderedProminent)
            
            Text(output)
                .font(.system(.caption, design: .monospaced))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(.gray.opacity(0.1))
                .clipShape(.rect(cornerRadius: 8))
        }
        .padding()
    }
    
    private func testExtension() {
        let fm = FileManager.default
        let fileName = "extension_test.txt"
        
        var results: [String] = []
        
        // Write
        do {
            let url = try fm.writeToDocuments(
                Data("Test content".utf8),
                fileName: fileName
            )
            results.append("Written to: \(url.lastPathComponent)")
        } catch {
            results.append("Write error: \(error)")
        }
        
        // Exists
        let exists = fm.existsInDocuments(fileName: fileName)
        results.append("Exists: \(exists)")
        
        // Read
        do {
            let content = try fm.readFromDocuments(fileName: fileName)
            results.append("Content: \(content)")
        } catch {
            results.append("Read error: \(error)")
        }
        
        // Delete
        do {
            try fm.deleteFromDocuments(fileName: fileName)
            results.append("Deleted successfully")
        } catch {
            results.append("Delete error: \(error)")
        }
        
        output = results.joined(separator: "\n")
    }
}

// MARK: - Preview

#Preview("Basic Read/Write") {
    BasicFileManagerExample()
}

#Preview("Directory Locations") {
    DirectoryLocationsExample()
}

#Preview("Codable Files") {
    CodableFileExample()
}

#Preview("List Directory") {
    ListDirectoryExample()
}

#Preview("Create Directory") {
    CreateDirectoryExample()
}

#Preview("File Attributes") {
    FileAttributesExample()
}

#Preview("Extension Methods") {
    FileManagerExtensionExample()
}
