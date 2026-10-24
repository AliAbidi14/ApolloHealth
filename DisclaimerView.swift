//
//  DisclaimerView.swift
//  ApolloHealth
//
//  Created by Ali Abidi on 8/20/26.
//
import SwiftUI

struct DisclaimerView: View {

    let language: AppLanguage
    let acknowledgmentRequired: Bool
    let onDismiss: () -> Void

    private var strings: AppStrings {
        AppStrings(language: language)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {

                    disclaimerSection(
                        title: strings.purposeTitle,
                        text: strings.purposeText
                    )

                    disclaimerSection(
                        title: strings.medicalDisclaimerTitle,
                        text: strings.medicalDisclaimerText
                    )

                    disclaimerSection(
                        title: strings.emergencyTitle,
                        text: strings.emergencyText
                    )

                    disclaimerSection(
                        title: strings.dataSourceTitle,
                        text: strings.dataSourceText
                    )

                    disclaimerSection(
                        title: strings.informationAccuracyTitle,
                        text: strings.informationAccuracyText
                    )

                    disclaimerSection(
                        title: strings.distanceInformationTitle,
                        text: strings.distanceInformationText
                    )

                    disclaimerSection(
                        title: strings.privacyTitle,
                        text: strings.privacyText
                    )

                    disclaimerSection(
                        title: strings.additionalResourcesTitle,
                        text: strings.additionalResourcesText
                    )

                    disclaimerSection(
                        title: strings.userResponsibilityTitle,
                        text: strings.userResponsibilityText
                    )

                    Button {
                        onDismiss()
                    } label: {
                        Text(
                            acknowledgmentRequired
                                ? strings.acknowledge
                                : strings.okay
                        )
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.top, 8)
                }
                .padding()
            }
            .navigationTitle(strings.disclaimerTitle)
            .navigationBarTitleDisplayMode(.inline)
        }
        .interactiveDismissDisabled(acknowledgmentRequired)
    }

    private func disclaimerSection(
        title: String,
        text: String
    ) -> some View {

        VStack(alignment: .leading, spacing: 7) {

            Text(title)
                .font(.headline)

            Text(text)
                .font(.body)
        }
    }
}
