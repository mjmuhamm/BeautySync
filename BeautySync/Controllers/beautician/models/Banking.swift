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

struct BusinessBankingInfo {

    let acceptTermsOfService: String
    let mccCode: String
    let ip: String
    let url: String
    let date: String
    let companyName: String
    let companyStreetAddress: String
    let companyCity: String
    let companyState: String
    let companyZipCode: String
    let companyPhone: String
    let companyTaxId: String
    var externalAccount: ExternalAccount?
    var representative: Person?
    var owners : [Person]?
    let documentId: String
    
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

struct Person {
    let stripeAccountId: String
    let personId: String
    let isPersonAnOwner: String
    let isPersonAnExectutive: String
    let firstName: String
    let lastName: String
    let month: String
    let day: String
    let year: String
    let streetAddress: String
    let city: String
    let state: String
    let zipCode: String
    let emailAddress: String
    let phoneNumber: String
    let taxId: String
    var go: String
}
