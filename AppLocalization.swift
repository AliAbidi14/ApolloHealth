//
//  AppLocalization.swift
//  ApolloHealth
//
//  Created by Ali Abidi on 8/20/26.
//

import Foundation

enum AppLanguage: String {
    case english = "en"
    case spanish = "es"
    case hmong = "hmn"
}

struct AppStrings {

    let language: AppLanguage

    // MARK: - Main Screen

    var emergencyBanner: String {
        switch language {
        case .english:
            return "If there is an emergency, call 9-1-1."
        case .spanish:
            return "Si hay una emergencia, llama al 9-1-1."
        case .hmong:
            return "Yog muaj xwm txheej ceev, hu rau 9-1-1."
        }
    }

    var useCurrentLocation: String {
        switch language {
        case .english:
            return "Use Current Location"
        case .spanish:
            return "Usar ubicación actual"
        case .hmong:
            return "Siv Koj Qhov Chaw Nyob Tam Sim No"
        }
    }

    var enterZip: String {
        switch language {
        case .english:
            return "Or Enter Zip Code"
        case .spanish:
            return "O ingresa el código postal"
        case .hmong:
            return "Los Yog Sau ZIP Code"
        }
    }
    
    var searchDistance: String {
        switch language {
        case .english:
            return "Search Distance in Miles (Required):"
        case .spanish:
            return "Distancia de búsqueda en millas (obligatorio):"
        case .hmong:
            return "Nrhiav Hauv Qhov Deb (mais) (Yuav Tsum Xaiv):"
        }
    }
    
    var miles: String {
        switch language {
        case .english:
            return "miles"
        case .spanish:
            return "millas"
        case .hmong:
            return "mais"
        }
    }

    var selectServices: String {
        switch language {
        case .english:
            return "Select Services (Required):"
        case .spanish:
            return "Selecciona servicios (obligatorio):"
        case .hmong:
            return "Xaiv Cov Kev Pab Cuam (Yuav Tsum Xaiv):"
        }
    }

    var search: String {
        switch language {
        case .english:
            return "Search"
        case .spanish:
            return "Buscar"
        case .hmong:
            return "Nrhiav"
        }
    }

    var selectDistance: String {
        switch language {
        case .english:
            return "Select Distance"
        case .spanish:
            return "Seleccione distancia"
        case .hmong:
            return "Xaiv Qhov Deb"
        }
    }

    // MARK: - Services

    var medical: String {
        switch language {
        case .english: return "Medical"
        case .spanish: return "Atención médica"
        case .hmong: return "Kev Kho Mob"
        }
    }

    var dental: String {
        switch language {
        case .english: return "Dental"
        case .spanish: return "Dental"
        case .hmong: return "Kev Kho Hniav"
        }
    }

    var physicalTherapy: String {
        switch language {
        case .english: return "Physical Therapy"
        case .spanish: return "Terapia física"
        case .hmong: return "Kev Kho Lub Cev"
        }
    }

    var behavioralHealth: String {
        switch language {
        case .english: return "Behavioral Health"
        case .spanish: return "Salud conductual"
        case .hmong: return "Kev Noj Qab Haus Huv Siab Ntsws"
        }
    }

    var pharmacy: String {
        switch language {
        case .english: return "Pharmacy"
        case .spanish: return "Farmacia"
        case .hmong: return "Tsev Muag Tshuaj"
        }
    }

    // MARK: - Location

    var invalidZip: String {
        switch language {
        case .english: return "Invalid ZIP Code"
        case .spanish: return "Código postal inválido"
        case .hmong: return "ZIP Code tsis raug"
        }
    }

    var locationAccessRequired: String {
        switch language {
        case .english:
            return "Location Access Required"
        case .spanish:
            return "Se requiere acceso a la ubicación"
        case .hmong:
            return "Yuav Tsum Tso Cai Siv Qhov Chaw Nyob"
        }
    }

    var locationRationale: String {
        switch language {
        case .english:
            return "ApolloHealth uses your current location to search for nearby clinics. Please allow location access."
        case .spanish:
            return "ApolloHealth usa tu ubicación actual para buscar clínicas cercanas. Permite el acceso a la ubicación."
        case .hmong:
            return "ApolloHealth siv koj qhov chaw nyob tam sim no los nrhiav cov chaw kho mob nyob ze koj. Thov tso cai siv qhov chaw nyob."
        }
    }

    var continueButton: String {
        switch language {
        case .english: return "Continue"
        case .spanish: return "Continuar"
        case .hmong: return "Mus Ntxiv"
        }
    }

    var cancelButton: String {
        switch language {
        case .english: return "Cancel"
        case .spanish: return "Cancelar"
        case .hmong: return "Tsis Ua"
        }
    }

    var locationPermissionNotGranted: String {
        switch language {
        case .english:
            return "Location permission not granted"
        case .spanish:
            return "No se concedió el permiso de ubicación"
        case .hmong:
            return "Tsis tau tso cai siv qhov chaw nyob"
        }
    }

    var locationFetched: String {
        switch language {
        case .english: return "Location fetched"
        case .spanish: return "Ubicación encontrada"
        case .hmong: return "Nrhiav tau qhov chaw nyob"
        }
    }

    var locationNotFetched: String {
        switch language {
        case .english:
            return "Location could not be fetched"
        case .spanish:
            return "No se pudo encontrar la ubicación"
        case .hmong:
            return "Nrhiav tsis tau qhov chaw nyob"
        }
    }

    var locationExplanation: String {
        switch language {
        case .english:
            return "ApolloHealth uses your current location to help you find nearby clinics."
        case .spanish:
            return "ApolloHealth usa tu ubicación actual para ayudarte a encontrar clínicas cercanas."
        case .hmong:
            return "ApolloHealth siv koj qhov chaw nyob tam sim no los pab nrhiav cov chaw kho mob nyob ze."
        }
    }

    // MARK: - Results
    var searchResultsTitle: String {
        switch language {
        case .english:
            return "Search Results"
        case .spanish:
            return "Resultados de búsqueda"
        case .hmong:
            return "Cov Tshwm Sim Nrhiav"
        }
    }
    
    func clinicsFound(_ count: Int) -> String {
        switch language {
        case .english:
            return "Clinics Found: \(count)"
        case .spanish:
            return "Clínicas encontradas: \(count)"
        case .hmong:
            return "Pom Tau Cov Chaw Kho Mob: \(count)"
        }
    }

    func distanceMiles(_ distance: Double) -> String {
        let value = String(format: "%.1f", distance)

        switch language {
        case .english:
            return "\(value) miles"
        case .spanish:
            return "\(value) millas"
        case .hmong:
            return "\(value) mais"
        }
    }
    
    var serviceTypeLabel: String {
        switch language {
        case .english:
            return "Service Type"
        case .spanish:
            return "Tipo de servicio"
        case .hmong:
            return "Hom Kev Pab Cuam"
        }
    }
    
    var distanceLabel: String {
        switch language {
        case .english:
            return "Distance"
        case .spanish:
            return "Distancia"
        case .hmong:
            return "Qhov Deb"
        }
    }
    
    var addressLabel: String {
        switch language {
        case .english:
            return "Address"
        case .spanish:
            return "Dirección"
        case .hmong:
            return "Chaw Nyob"
        }
    }

    var phoneLabel: String {
        switch language {
        case .english:
            return "Phone"
        case .spanish:
            return "Teléfono"
        case .hmong:
            return "Xov Tooj"
        }
    }

    var call: String {
        switch language {
        case .english: return "Call"
        case .spanish: return "Llamar"
        case .hmong: return "Hu"
        }
    }

    var directions: String {
        switch language {
        case .english: return "Directions"
        case .spanish: return "Direcciones"
        case .hmong: return "Kev Taw Qhia"
        }
    }

    var website: String {
        switch language {
        case .english: return "Website"
        case .spanish: return "Sitio web"
        case .hmong: return "Lub Vev Xaib"
        }
    }

    // MARK: - Disclaimer

    var disclaimerTitle: String {
        switch language {
        case .english:
            return "Disclaimer & Privacy Notice"
        case .spanish:
            return "Aviso legal y de privacidad"
        case .hmong:
            return "Lus Ceeb Toom thiab Kev Tiv Thaiv Ntaub Ntawv"
        }
    }

    var acknowledge: String {
        switch language {
        case .english: return "I Acknowledge"
        case .spanish: return "Reconozco y acepto"
        case .hmong: return "Kuv Nkag Siab"
        }
    }

    var okay: String {
        switch language {
        case .english: return "OK"
        case .spanish: return "Entendido"
        case .hmong: return "Kuv Nkag Siab"
        }
    }
    
    var purposeTitle: String {
        switch language {
        case .english:
            return "Purpose"
        case .spanish:
            return "Propósito"
        case .hmong:
            return "Lub Hom Phiaj"
        }
    }

    var purposeText: String {
        switch language {
        case .english:
            return "ApolloHealth is a community health resource application developed by SEHAT, a youth-led nonprofit organization based in Onalaska, Wisconsin. It is designed to help individuals and families identify healthcare services and resources. Information provided through this application is for informational and educational purposes only."

        case .spanish:
            return "ApolloHealth es una aplicación comunitaria de recursos de salud desarrollada por SEHAT, una organización sin fines de lucro dirigida por jóvenes y con sede en Onalaska, Wisconsin. Está diseñada para ayudar a las personas y las familias a identificar servicios y recursos de atención médica. La información proporcionada a través de esta aplicación tiene únicamente fines informativos y educativos."

        case .hmong:
            return "ApolloHealth yog ib daim ntawv thov pab nrhiav kev kho mob thiab lwm yam kev pab cuam hauv zej zog uas tsim los ntawm SEHAT, ib lub koom haum tsis nrhiav nyiaj tau los uas cov hluas yog tus coj, nyob hauv Onalaska, Wisconsin. Daim ntawv thov no yog tsim los pab tib neeg thiab tsev neeg nrhiav cov kev pab cuam thiab cov chaw kho mob. Cov ntaub ntawv muaj nyob hauv daim ntawv thov no yog rau kev qhia paub thiab kev kawm xwb."
        }
    }
    
    var medicalDisclaimerTitle: String {
        switch language {
        case .english:
            return "Medical Disclaimer"
        case .spanish:
            return "Aviso Médico"
        case .hmong:
            return "Lus Ceeb Toom Txog Kev Kho Mob"
        }
    }

    var medicalDisclaimerText: String {
        switch language {
        case .english:
            return "ApolloHealth is not a substitute for professional medical advice, diagnosis, or treatment. Always seek the advice of a qualified healthcare professional regarding any medical condition or healthcare decision."

        case .spanish:
            return "ApolloHealth no sustituye el consejo, diagnóstico ni tratamiento médico profesional. Siempre consulte a un profesional de la salud calificado sobre cualquier condición médica o decisión relacionada con su atención médica."

        case .hmong:
            return "ApolloHealth tsis yog los hloov kev sab laj, kev kuaj mob, lossis kev kho mob los ntawm kws kho mob. Thov ib txwm sab laj nrog kws kho mob uas tsim nyog txog txhua yam teeb meem kev noj qab haus huv lossis kev txiav txim siab txog kev kho mob."
        }
    }
    
    var dataSourceTitle: String {
        switch language {
        case .english:
            return "Data Source"
        case .spanish:
            return "Fuente de los Datos"
        case .hmong:
            return "Qhov Chaw Tau Cov Ntaub Ntawv"
        }
    }

    var dataSourceText: String {
        switch language {
        case .english:
            return "ApolloHealth uses publicly available data from the U.S. Health Resources and Services Administration (HRSA), including information related to Federally Qualified Health Centers (FQHCs) and other healthcare facilities. While every effort is made to provide accurate and up-to-date information, ApolloHealth does not independently verify all information contained within external databases."

        case .spanish:
            return "ApolloHealth utiliza datos públicos disponibles de la Administración de Recursos y Servicios de Salud de los Estados Unidos (HRSA), incluida información relacionada con los Centros de Salud Calificados Federalmente (FQHC) y otros centros de atención médica. Aunque se realizan esfuerzos para proporcionar información precisa y actualizada, ApolloHealth no verifica de manera independiente toda la información contenida en bases de datos externas."

        case .hmong:
            return "ApolloHealth siv cov ntaub ntawv pej xeem uas muaj los ntawm U.S. Health Resources and Services Administration (HRSA), suav nrog cov ntaub ntawv hais txog Federally Qualified Health Centers (FQHCs) thiab lwm cov chaw kho mob. Txawm tias peb siv zog los muab cov ntaub ntawv raug thiab tshiab, ApolloHealth tsis tuaj yeem lees paub tias txhua yam ntaub ntawv hauv cov chaw khaws ntaub ntawv sab nraud yeej raug tas nrho."
        }
    }
    
    var informationAccuracyTitle: String {
        switch language {
        case .english:
            return "Information Accuracy"
        case .spanish:
            return "Exactitud de la Información"
        case .hmong:
            return "Qhov Tseeb ntawm Cov Ntaub Ntawv"
        }
    }

    var informationAccuracyText: String {
        switch language {
        case .english:
            return "Clinic information, services offered, hours of operation, eligibility requirements, phone numbers, websites, addresses, and availability may change without notice. Users are strongly encouraged to contact healthcare providers directly to verify information before making healthcare decisions or scheduling appointments."

        case .spanish:
            return "La información sobre clínicas, servicios ofrecidos, horarios de atención, requisitos de elegibilidad, números telefónicos, sitios web, direcciones y disponibilidad puede cambiar sin previo aviso. Se recomienda encarecidamente a los usuarios que se comuniquen directamente con los proveedores de atención médica para verificar la información antes de tomar decisiones relacionadas con su salud o programar citas."

        case .hmong:
            return "Cov ntaub ntawv hais txog cov chaw kho mob, cov kev pab cuam, sijhawm ua haujlwm, kev tsim nyog tau txais kev pab, xov tooj, vev xaib, chaw nyob, thiab kev muaj kev pab yuav hloov tau yam tsis muaj kev ceeb toom ua ntej. Thov hu ncaj qha rau cov chaw kho mob kom paub tseeb txog cov ntaub ntawv ua ntej txiav txim siab txog kev kho mob lossis teem sijhawm."
        }
    }
    
    var distanceInformationTitle: String {
        switch language {
        case .english:
            return "Distance Information"
        case .spanish:
            return "Información sobre Distancias"
        case .hmong:
            return "Cov Ntaub Ntawv Txog Kev Deb"
        }
    }

    var distanceInformationText: String {
        switch language {
        case .english:
            return "Distances displayed within the application are approximate and may not reflect actual driving routes, travel times, transportation availability, or current road conditions."

        case .spanish:
            return "Las distancias mostradas en la aplicación son aproximadas y pueden no reflejar las rutas reales de conducción, los tiempos de viaje, la disponibilidad de transporte o las condiciones actuales de las carreteras."

        case .hmong:
            return "Cov kev deb uas pom hauv daim ntawv thov no yog kev kwv yees xwb thiab tej zaum yuav tsis phim qhov kev mus tiag tiag, sijhawm taug kev, kev muaj tsheb thauj mus los, lossis cov xwm txheej ntawm txoj kev."
        }
    }
    
    var privacyTitle: String {
        switch language {
        case .english:
            return "Privacy"
        case .spanish:
            return "Privacidad"
        case .hmong:
            return "Kev Tiv Thaiv Ntaub Ntawv"
        }
    }

    var privacyText: String {
        switch language {
        case .english:
            return "ApolloHealth does not collect, store, sell, or share personal health information. Location information is used solely to perform clinic searches and is not retained by the application. No warranty, express or implied, is made regarding the completeness, accuracy, reliability, or suitability of the information provided."

        case .spanish:
            return "ApolloHealth no recopila, almacena, vende ni comparte información personal de salud. La información de ubicación se utiliza únicamente para realizar búsquedas de clínicas y no es conservada por la aplicación. No se ofrece ninguna garantía, expresa o implícita, con respecto a la integridad, exactitud, confiabilidad o idoneidad de la información proporcionada."

        case .hmong:
            return "ApolloHealth tsis khaws, muag, lossis qhia tawm koj cov ntaub ntawv kev noj qab haus huv. Koj qhov chaw nyob raug siv nkaus xwb los pab nrhiav cov chaw kho mob nyob ze thiab tsis raug khaws cia. Tsis muaj kev lees paub, ncaj qha lossis tsis ncaj qha, hais txog qhov ua tiav, raug, ntseeg tau, lossis tsim nyog ntawm cov ntaub ntawv muab los ntawm daim ntawv thov no."
        }
    }
    
    var additionalResourcesTitle: String {
        switch language {
        case .english:
            return "Additional Resources"
        case .spanish:
            return "Recursos Adicionales"
        case .hmong:
            return "Lwm Cov Kev Pab"
        }
    }

    var additionalResourcesText: String {
        switch language {
        case .english:
            return "For additional healthcare resources and educational materials, visit https://sehatnonprofit.org."

        case .spanish:
            return "Para obtener más recursos de salud, materiales educativos y servicios de apoyo comunitario, visite: https://sehatnonprofit.org"

        case .hmong:
            return "Yog xav paub ntxiv txog kev noj qab haus huv, ntaub ntawv qhia, thiab lwm yam kev pab hauv zej zog, thov mus saib: https://sehatnonprofit.org"
        }
    }
    
    var userResponsibilityTitle: String {
        switch language {
        case .english:
            return "User Responsibility"
        case .spanish:
            return "Responsabilidad del Usuario"
        case .hmong:
            return "Lub Luag Haujlwm ntawm Tus Neeg Siv"
        }
    }

    var userResponsibilityText: String {
        switch language {
        case .english:
            return "By using ApolloHealth, you acknowledge that you are responsible for independently verifying healthcare information and determining the suitability of services and resources for your individual needs."

        case .spanish:
            return "Al utilizar ApolloHealth, usted reconoce que es responsable de verificar de manera independiente la información de atención médica y de determinar si los servicios y recursos son adecuados para sus necesidades individuales."

        case .hmong:
            return "Los ntawm kev siv ApolloHealth, koj lees paub tias koj yog tus muaj lub luag haujlwm los xyuas kom meej cov ntaub ntawv kho mob thiab txiav txim siab seb cov kev pab cuam puas haum rau koj tus kheej qhov kev xav tau."
        }
    }
    
    var emergencyTitle: String {
        switch language {
        case .english:
            return "Emergency"
        case .spanish:
            return "Emergencia"
        case .hmong:
            return "Xwm Txheej Ceev"
        }
    }
    
    var emergencyText: String {
        switch language {
        case .english:
            return "If you are experiencing a medical emergency, call 9-1-1 immediately."
        case .spanish:
            return "Si está experimentando una emergencia médica, llame inmediatamente al 9-1-1."
        case .hmong:
            return "Yog muaj xwm txheej ceev, hu rau 9-1-1 tam sim ntawd."
        }
    }
    
    var locationPermissionRequired: String {
        switch language {
        case .english:
            return "Location permission required"
        case .spanish:
            return "Se requiere permiso de ubicación"
        case .hmong:
            return "Yuav tsum tso cai siv qhov chaw nyob"
        }
    }

    var locationAccessDenied: String {
        switch language {
        case .english:
            return "Location access is denied. Please enable it in settings."
        case .spanish:
            return "El acceso a la ubicación está denegado. Actívalo en Configuración."
        case .hmong:
            return "Tsis tau tso cai siv qhov chaw nyob. Thov qhib qhov kev tso cai hauv Chaw Teeb Tseg."
        }
    }

    var usingCurrentLocation: String {
        switch language {
        case .english:
            return "Using your current location"
        case .spanish:
            return "Usando tu ubicación actual"
        case .hmong:
            return "Siv koj qhov chaw nyob tam sim no"
        }
    }

    var unknownLocationStatus: String {
        switch language {
        case .english:
            return "Unknown location status"
        case .spanish:
            return "Estado de ubicación desconocido"
        case .hmong:
            return "Tsis paub qhov xwm txheej ntawm qhov chaw nyob"
        }
    }
}
