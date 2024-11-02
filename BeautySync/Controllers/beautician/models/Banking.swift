//
//  Banking.swift
//  BeautySync
//
//  Created by Malik Muhammad on 11/2/24.
//

import Foundation

struct IndividualBankingInfo {
    let acceptTermsOfService: String
    let mccCode: String
    let ip: String
    let businessUrl: String
    let date: String
    let firstName: String
    let lastName: String
    let dobMonth: String
    let dobDay: String
    let dobYear: String
    let streetAddress: String
    let line2: String
    let city: String
    let state: String
    let zipCode: String
    let email: String
    let phone: String
    let ssn: String
    var externalAccount: ExternalAccount?
    
}

struct ExternalAccount {
    let accountType: String
    let stripeAccountId: String
    let externalAccountId: String
    let bankName: String
    let accountHolder: String
    let accountNumber: String
    let routingNumber: String
    let documentId: String
    var go: String
}
