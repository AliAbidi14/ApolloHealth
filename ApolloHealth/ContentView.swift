
//  ContentView.swift
//  ApolloHealth
//
//  Created by Ali Abidi for the 2024 Congressional App Challenge.


import SwiftUI
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var currentLocation: CLLocation?
    @Published var locationStatus: CLAuthorizationStatus = .notDetermined
    
    override init() {
        super.init()
        locationManager.delegate = self
    }

    // Asking user to allow access to current location with options
    func requestLocationAccess() {
        let status = locationManager.authorizationStatus
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        case .restricted, .denied:
            break
        @unknown default:
            break
        }
    }

    // Reading current location authorization status based on user input
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        DispatchQueue.main.async {
            self.locationStatus = status
            switch status {
            case .authorizedWhenInUse, .authorizedAlways:
                self.locationManager.requestLocation()
            case .notDetermined:
                break
            case .restricted, .denied:
                self.currentLocation = nil
            @unknown default:
                break
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        DispatchQueue.main.async {
            self.currentLocation = locations.last
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager error: \(error)")
    }
}

//Creating user interface for the input search screen
struct InputScreenView: View {
    @State private var zipCode: String = ""
    @State private var selectedDistance: Int = 5
    @State private var selectedServices: Set<String> = []
    @State private var results: [Clinic] = []
    @State private var isLoading: Bool = false
    @State private var errorMessage: String? = nil
    @State private var isUsingCurrentLocation: Bool = false
    @State private var showResults: Bool = false
    
    let distanceOptions = [5, 10, 25, 50, 100]
    let serviceOptions = ["Medical", "Dental", "Physical Therapy", "Behavioral Health", "Pharmacy"]
    
    @StateObject private var locationManager = LocationManager()
    private let geocoder = CLGeocoder()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("This service is currently available only in the state of Wisconsin")
                        .font(.system(size: 17, weight: .semibold))
                        .padding()
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(8)
                        .padding(.top, 32)
                    
                    Toggle(isOn: $isUsingCurrentLocation) {
                        VStack(alignment: .leading) {
                            Text("Use Current Location")
                            Text("Or Enter Zip Code Below")
                                .font(.subheadline)
                                .foregroundColor(.gray)

                        }
                    }
                    .tint(.blue)
                    .onChange(of: isUsingCurrentLocation) {
                        if isUsingCurrentLocation {
                            locationManager.requestLocationAccess()
                        }
                    }
                    
                    if isUsingCurrentLocation {
                        switch locationManager.locationStatus {
                        case .notDetermined:
                            Text("Location permission required")
                                .foregroundColor(.red)
                        case .restricted, .denied:
                            Text("Location access is denied. Please enable it in settings.")
                                .foregroundColor(.red)
                        case .authorizedWhenInUse, .authorizedAlways:
                            Text("Using your current location")
                        @unknown default:
                            Text("Unknown location status")
                                .foregroundColor(.red)
                        }
                    } else {
                        TextField("Enter Zip Code", text: $zipCode)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                            .onChange(of: zipCode) {
                                if zipCode.count > 5 {
                                    zipCode = String(zipCode.prefix(5))
                                }
                            }
                            .onReceive(NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification)) { _ in
                                if zipCode.count == 5 {
                                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                }
                            }
                            .padding(.top, 8)
                    }
                    
                    HStack {
                        Text("Select Distance:")
                            .font(.headline)
                        Spacer()
                        Picker("Select the Distance", selection: $selectedDistance) {
                            ForEach(distanceOptions, id: \.self) { distance in
                                Text("\(distance) miles").tag(distance)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding()
                    }
                    .padding()
                    
                    VStack(alignment: .leading) {
                        Text("Select Services (Required):")
                            .font(.headline)
                        ForEach(serviceOptions, id: \.self) { service in
                            Toggle(service, isOn: Binding(
                                get: { self.selectedServices.contains(service) },
                                set: { isChecked in
                                    if isChecked {
                                        self.selectedServices.insert(service)
                                    } else {
                                        self.selectedServices.remove(service)
                                    }
                                }
                            ))
                            .padding(.vertical, 2)
                            .tint(.blue)
                        }
                    }
                    .padding()
                    
                    VStack {
                        Button {
                            performSearch()
                            showResults = true
                        } label: {
                            Text("Search")
                                .padding()
                                .font(.headline)
                                .foregroundColor(Color.white)
                                .frame(maxWidth: 350)
                                .clipShape(Capsule())
                        }
                        .disabled(!isSearchButtonEnabled)
                        .background(isSearchButtonEnabled ? Color(.systemBlue) : Color.gray)
                        .clipShape(Capsule())
                        .padding(.horizontal, -32)
                        .padding()
                    }
                    .frame(maxWidth: .infinity)
                    
                    NavigationLink(
                        destination: SearchResultsView(results: $results, isLoading: $isLoading, errorMessage: $errorMessage, locationManager: locationManager),
                        isActive: $showResults
                    ) {
                        EmptyView()
                    }
                }
                .padding()
            }
            .background(Color(UIColor.systemBackground))
            .edgesIgnoringSafeArea(.all)
            .navigationBarHidden(true)
        }
    }
    
    private var isSearchButtonEnabled: Bool {
        let locationCondition = isUsingCurrentLocation ? locationManager.currentLocation != nil : !zipCode.isEmpty
        let serviceCondition = selectedServices.count > 0
        
        return locationCondition && serviceCondition
    }

    // Conditional check for user current location or zipcode input
    func performSearch() {
        if isUsingCurrentLocation {
            guard let userLocation = locationManager.currentLocation else {
                errorMessage = "Unable to get current location."
                return
            }
            searchNearbyClinics(using: userLocation)
        } else {
            guard !zipCode.isEmpty else {
                errorMessage = "Please enter a ZIP code."
                return
            }
            
            isLoading = true
            errorMessage = nil
            
            geocode(zipCode: zipCode) { location in
                guard let location = location else {
                    DispatchQueue.main.async {
                        self.errorMessage = "Failed to get location for ZIP code."
                        self.isLoading = false
                    }
                    return
                }
                
                searchNearbyClinics(using: location)
            }
        }
    }
    
    // Converting zipcode to location coordinates using geocoder and error handling
    func geocode(zipCode: String, completion: @escaping (CLLocation?) -> Void) {
        geocoder.geocodeAddressString(zipCode) { placemarks, error in
            if let error = error {
                print("Geocoding error: \(error)")
                completion(nil)
                return
            }
            
            guard let placemark = placemarks?.first,
                  let location = placemark.location else {
                print("No location found for zip code")
                completion(nil)
                return
            }
            
            completion(location)
        }
    }
    
    // Accessing CSV file and filtering the clinics based on search criteria
    func searchNearbyClinics(using location: CLLocation) {
        guard let csvURL = Bundle.main.url(forResource: "addressesfinal", withExtension: "csv") else {
            DispatchQueue.main.async {
                self.errorMessage = "CSV file not found."
                self.isLoading = false
            }
            return
        }
        
        do {
            let csvData = try Data(contentsOf: csvURL)
            guard let csvString = String(data: csvData, encoding: .utf8) else {
                throw NSError(domain: "ContentConversionError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to convert CSV data to string."])
            }
            
            let clinics = parseCSV(from: csvString)
            
            results = clinics.map { clinic in
                let clinicLocation = CLLocation(latitude: clinic.latitude, longitude: clinic.longitude)
                let distance = location.distance(from: clinicLocation) / 1609.34 // Convert meters to miles
                var clinic = clinic
                clinic.distance = distance
                return clinic
            }
            .filter { clinic in
                clinic.distance <= Double(selectedDistance)
            }
            .filter { clinic in
                selectedServices.isEmpty || !clinic.serviceTypes.isDisjoint(with: selectedServices)
            }
            .sorted { $0.distance < $1.distance }
            
            DispatchQueue.main.async {
                self.isLoading = false
            }
        } catch {
            print("Error reading CSV file: \(error)")
            DispatchQueue.main.async {
                self.errorMessage = "Failed to read CSV file."
                self.isLoading = false
            }
        }
    }
    
    // Parsing filtered data from the CSV file and matching information to each clinic's template
    func parseCSV(from csvString: String) -> [Clinic] {
        var clinics: [Clinic] = []
        let lines = csvString.components(separatedBy: .newlines).map { $0.trimmingCharacters(in: .whitespaces) }
        
        guard lines.count > 1 else {
            print("CSV file is empty or does not have enough lines.")
            return clinics
        }
        
        let headers = parseCSVLine(lines.first ?? "")
        
        for line in lines.dropFirst() {
            guard !line.isEmpty else { continue }
            
            let columns = parseCSVLine(line)
            guard columns.count == headers.count else {
                print("Column count mismatch in line: \(line)")
                continue
            }
            
            let rowDict = Dictionary(uniqueKeysWithValues: zip(headers, columns))
            
            guard let clinicName = rowDict["Clinic Name"],
                  let serviceType = rowDict["Service Type"],
                  let address = rowDict["Address"],
                  let phone = rowDict["Phone"],
                  let website = rowDict["Website"],
                  let latitudeString = rowDict["Latitude"],
                  let longitudeString = rowDict["Longitude"],
                  let latitude = Double(latitudeString),
                  let longitude = Double(longitudeString) else {
                print("Missing or invalid data in row: \(rowDict)")
                continue
            }
            
            let serviceTypes = serviceType.split(separator: "&").map { $0.trimmingCharacters(in: .whitespaces) }
            let clinic = Clinic(clinicName: clinicName, serviceTypes: Set(serviceTypes), address: address, phone: phone, website: website, latitude: latitude, longitude: longitude)
            clinics.append(clinic)
        }
        
        return clinics
    }
    
    func parseCSVLine(_ line: String) -> [String] {
        var result: [String] = []
        var current = ""
        var insideQuote = false
        
        for char in line {
            switch char {
            case ",":
                if insideQuote {
                    current.append(char)
                } else {
                    result.append(current)
                    current = ""
                }
            case "\"":
                insideQuote.toggle()
                current.append(char)
            default:
                current.append(char)
            }
        }
        
        if !current.isEmpty {
            result.append(current)
        }
        
        return result
    }
}

// Creating page and user interface for the search results
struct SearchResultsView: View {
    @Binding var results: [Clinic]
    @Binding var isLoading: Bool
    @Binding var errorMessage: String?
    @ObservedObject var locationManager: LocationManager
    
    @State private var showInfoPopover = false
    @State private var showCallConfirmation = false
    @State private var selectedPhoneNumber: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Number of clinics found: \(results.count)")
                .font(.headline)
                .padding(.top, 96)
            
            if isLoading {
                ProgressView()
                    .padding()
            } else if let errorMessage = errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
                    .padding()
            } else if results.isEmpty {
                Text("No results found")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        ForEach(results.sorted { $0.distance < $1.distance }) { clinic in
                            VStack(alignment: .leading, spacing: 8) {
                                Text(clinic.clinicName)
                                    .font(.headline)
                                    .bold()
                                Text("Service Type: \(clinic.serviceTypes.joined(separator: ", "))")
                                Text("Address: \(clinic.address)")
                                Text("Phone: \(clinic.phone)")
                                Text("Distance: \(clinic.distance, specifier: "%.2f") miles")
                                
                                HStack {
                                    if let websiteURL = URL(string: clinic.website) {
                                        Button(action: {
                                            UIApplication.shared.open(websiteURL)
                                        }) {
                                            Text("Website")
                                                .font(.headline)
                                                .foregroundColor(.white)
                                                .padding(.horizontal, 16)
                                                .padding(.vertical, 8)
                                                .background(Color.blue)
                                                .clipShape(Capsule())
                                        }
                                        .padding(.trailing, 8)
                                    }
                                    
                                    if let currentLocation = locationManager.currentLocation {
                                        let directionsURL = URL(string: "https://www.google.com/maps/dir/?api=1&origin=\(currentLocation.coordinate.latitude),\(currentLocation.coordinate.longitude)&destination=\(clinic.latitude),\(clinic.longitude)&travelmode=driving")!
                                        Button(action: {
                                            UIApplication.shared.open(directionsURL)
                                        }) {
                                            Text("Directions")
                                                .font(.headline)
                                                .foregroundColor(.white)
                                                .padding(.horizontal, 16)
                                                .padding(.vertical, 8)
                                                .background(Color.blue)
                                                .clipShape(Capsule())
                                        }
                                        .padding(.trailing, 8)
                                    }
                                    
                                    Button(action: {
                                        selectedPhoneNumber = clinic.phone
                                        showCallConfirmation = true
                                    }) {
                                        Text("Call")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 8)
                                            .background(Color.blue)
                                            .clipShape(Capsule())
                                    }
                                }
                            }
                            .padding(.vertical, 8)
                            Divider()
                                .frame(height: 4)
                                .background(Color.gray)
                        }
                    }
                }
            }
        }
        .padding(.horizontal)
        .background(Color(UIColor.systemBackground))
        .edgesIgnoringSafeArea(.all)
        .navigationTitle("Search Results")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showInfoPopover = true
                }) {
                    Image(systemName: "info.circle")
                        .font(.body)
                }
                .popover(isPresented: $showInfoPopover) {
                    GeometryReader { geometry in
                        ZStack(alignment: .topLeading) {
                            VStack(alignment: .leading, spacing: 16) {
                                Text("\nDisclosure Statement:")
                                    .font(.title3)
                                    .padding(.top, 16)
                                Text("The results provided via search in the ApolloHealth application are based on the database available from the Wisconsin Department of Health Services. For more detailed information about the clinics and the services they offer, please visit the respective clinic's website or contact the clinic directly.\n\nPlease note that the distances provided are straight-line distances between the input location and the destination clinic. Actual driving distances may vary depending on driving routes and conditions. To obtain driving distances and directions, please click on 'Directions' in the search results.")
                                    .font(.caption)
                                    .padding(.top, 8)
                                Spacer()
                            }
                            .frame(width: geometry.size.width * 0.8)
                            .padding()
                            
                            Button(action: {
                                showInfoPopover = false
                            }) {
                                Image(systemName: "xmark")
                                    .font(.body)
                                    .padding()
                            }
                            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .topLeading)
                        }
                    }
                    .frame(width: 400, height: 740)
                }
            }
        }
        .alert(isPresented: $showCallConfirmation) {
            Alert(
                title: Text("Call Clinic"),
                message: Text("Do you want to call \(selectedPhoneNumber)?"),
                primaryButton: .default(Text("Yes")) {
                    if let phoneURL = URL(string: "tel://\(selectedPhoneNumber)") {
                        UIApplication.shared.open(phoneURL)
                    }
                },
                secondaryButton: .cancel(Text("No"))
            )
        }
    }
}

//Creating template for the clinic result
struct Clinic: Identifiable, Equatable {
    let id = UUID()
    let clinicName: String
    let serviceTypes: Set<String>
    let address: String
    let phone: String
    let website: String
    let latitude: Double
    let longitude: Double
    var distance: Double = 0.0
}
