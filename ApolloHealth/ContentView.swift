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
struct ServiceOption: Identifiable, Hashable {
    let id: String
    let displayName: String
}

struct InputScreenView: View {
    let language: AppLanguage
    @AppStorage("acknowledgedDisclaimerVersion")
    private var acknowledgedDisclaimerVersion: Int = 0
    private let currentDisclaimerVersion = 2
    @State private var showLaunchDisclaimer = false
    private var strings: AppStrings {
        AppStrings(language: language)
    }
    @State private var zipCode: String = ""
    @State private var selectedDistance: Int = 5
    @State private var selectedServices: Set<String> = []
    @State private var results: [Clinic] = []
    @State private var isLoading: Bool = false
    @State private var errorMessage: String? = nil
    @State private var isUsingCurrentLocation: Bool = false
    @State private var showResults: Bool = false
    @State private var geocodedLocation: CLLocation? = nil
    
    let distanceOptions = [5, 10, 25, 50, 100]
    private var serviceOptions: [ServiceOption] {
        [
            ServiceOption(
                id: "Medical",
                displayName: strings.medical
            ),
            ServiceOption(
                id: "Dental",
                displayName: strings.dental
            ),
            ServiceOption(
                id: "Physical Therapy",
                displayName: strings.physicalTherapy
            ),
            ServiceOption(
                id: "Behavioral Health",
                displayName: strings.behavioralHealth
            ),
            ServiceOption(
                id: "Pharmacy",
                displayName: strings.pharmacy
            )
        ]
    }
    
    @StateObject private var locationManager = LocationManager()
    private let geocoder = CLGeocoder()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text(strings.emergencyBanner)
                        .font(.system(size: 17, weight: .semibold))
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(8)
                        .padding(.top, 32)
                    
                    Toggle(isOn: $isUsingCurrentLocation) {
                        Text(strings.useCurrentLocation)
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
                            Text(strings.locationPermissionRequired)
                                .foregroundColor(.red)

                        case .restricted, .denied:
                            Text(strings.locationAccessDenied)
                                .foregroundColor(.red)

                        case .authorizedWhenInUse, .authorizedAlways:
                            Text(strings.usingCurrentLocation)

                        @unknown default:
                            Text(strings.unknownLocationStatus)
                                .foregroundColor(.red)
                        }
                    } else {
                        TextField(strings.enterZip, text: $zipCode)
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
                        Text(strings.searchDistance)
                            .font(.headline)
                        Spacer()
                        Picker(strings.selectDistance, selection: $selectedDistance) {
                            ForEach(distanceOptions, id: \.self) { distance in
                                Text("\(distance) \(strings.miles)").tag(distance)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding()
                    }
                    .padding()
                    
                    VStack(alignment: .leading) {
                        Text(strings.selectServices)
                            .font(.headline)
                        ForEach(serviceOptions) { service in
                            
                            Toggle(
                                service.displayName,
                                isOn: Binding(
                                    get: {
                                        self.selectedServices.contains(service.id)
                                    },
                                    set: { isChecked in
                                        if isChecked {
                                            self.selectedServices.insert(service.id)
                                        } else {
                                            self.selectedServices.remove(service.id)
                                        }
                                    }
                                )
                            )
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
                            Text(strings.search)
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
                    
                    .navigationDestination(isPresented: $showResults) {
                        SearchResultsView(
                            results: $results,
                            isLoading: $isLoading,
                            errorMessage: $errorMessage,
                            locationManager: locationManager,
                            geocodedLocation: geocodedLocation,
                            language: language
                        )
                    }

                }
                .padding()
            }
            .background(Color(UIColor.systemBackground))
            .edgesIgnoringSafeArea(.all)
            .navigationBarHidden(true)
        }
        
        .onAppear {
            if acknowledgedDisclaimerVersion < currentDisclaimerVersion {
                showLaunchDisclaimer = true
            }
        }
        .sheet(isPresented: $showLaunchDisclaimer) {
            DisclaimerView(
                language: language,
                acknowledgmentRequired: true
            ) {
                acknowledgedDisclaimerVersion = currentDisclaimerVersion
                showLaunchDisclaimer = false
            }
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

                DispatchQueue.main.async {
                    self.geocodedLocation = location // Save the geocoded location
                    self.searchNearbyClinics(using: location)
                }
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
        guard let csvURL = Bundle.main.url(forResource: "addressesall", withExtension: "csv") else {
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

func ensureCorrectScheme(for url: String) -> String {
    if url.hasPrefix("http://") || url.hasPrefix("https://") {
        return url // Use the existing scheme
    } else {
        return "https://\(url)" // Default to HTTPS if no scheme is present
    }
}

struct SearchResultsView: View {
    @Binding var results: [Clinic]
    @Binding var isLoading: Bool
    @Binding var errorMessage: String?
    @ObservedObject var locationManager: LocationManager
    var geocodedLocation: CLLocation?
    let language: AppLanguage
    private var strings: AppStrings {
        AppStrings(language: language)
    }
    @State private var showInfoPopover = false
    @State private var showCallConfirmation = false
    @State private var selectedPhoneNumber: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            if isLoading {

                ProgressView()
                    .padding(.top, 96)
                    .frame(maxWidth: .infinity)

            } else if let errorMessage = errorMessage {

                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
                    .padding(.top, 96)
                    .frame(maxWidth: .infinity)

            } else if results.isEmpty {

                VStack {
                    Spacer()

                    Text(strings.clinicsFound(0))
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)

                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            } else {

                Text(strings.clinicsFound(results.count))
                    .font(.headline)
                    .padding(.top, 96)

                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        ForEach(results.sorted { $0.distance < $1.distance }) { clinic in
                            VStack(alignment: .leading, spacing: 8) {
                                Text(clinic.clinicName)
                                    .font(.headline)
                                    .bold()
                                Text(
                                    "\(strings.serviceTypeLabel): " +
                                    clinic.serviceTypes
                                        .map { translatedServiceName($0) }
                                        .joined(separator: ", ")
                                )
                                Text("\(strings.addressLabel): \(clinic.address)")
                                Text("\(strings.phoneLabel): \(clinic.phone)")
                                Text("\(strings.distanceLabel): \(strings.distanceMiles(clinic.distance))")
                                
                                HStack {
                                    if let websiteURL = URL(string: ensureCorrectScheme(for: clinic.website)) {
                                        Button(action: {
                                            UIApplication.shared.open(websiteURL)
                                        }) {
                                            Text(strings.website)
                                                .font(.headline)
                                                .foregroundColor(.white)
                                                .padding(.horizontal, 16)
                                                .padding(.vertical, 8)
                                                .background(Color.blue)
                                                .cornerRadius(20)
                                        }
                                        .padding(.trailing, 8)
                                    }
                                    
                                    if let originLocation = locationManager.currentLocation ?? geocodedLocation {
                                        let directionsURL = URL(string: "https://www.google.com/maps/dir/?api=1&origin=\(originLocation.coordinate.latitude),\(originLocation.coordinate.longitude)&destination=\(clinic.latitude),\(clinic.longitude)&travelmode=driving")!
                                        Button(action: {
                                            UIApplication.shared.open(directionsURL)
                                        }) {
                                            Text(strings.directions)
                                                .font(.headline)
                                                .foregroundColor(.white)
                                                .padding(.horizontal, 16)
                                                .padding(.vertical, 8)
                                                .background(Color.blue)
                                                .cornerRadius(20)
                                        }
                                        .padding(.trailing, 8)
                                    }

                                    
                                    Button(action: {
                                        selectedPhoneNumber = clinic.phone
                                        showCallConfirmation = true
                                    }) {
                                        Text(strings.call)
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
        .navigationTitle(strings.searchResultsTitle)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showInfoPopover = true
                }) {
                    Image(systemName: "info.circle")
                        .font(.body)
                }
                .sheet(isPresented: $showInfoPopover) {
                    DisclaimerView(
                        language: language,
                        acknowledgmentRequired: false
                    ) {
                        showInfoPopover = false
                    }
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
    
    private func translatedServiceName(_ service: String) -> String {
        switch service.lowercased() {
        case "medical":
            return strings.medical

        case "dental":
            return strings.dental

        case "physical therapy":
            return strings.physicalTherapy

        case "behavioral health":
            return strings.behavioralHealth

        case "pharmacy":
            return strings.pharmacy

        default:
            return service
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
