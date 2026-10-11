//
//  Agent.swift
//  Real_State
//
//  Contacto comercial al que se dirigen llamadas y mensajes de una propiedad.
//

import Foundation

struct Agent: Identifiable {
    let id: UUID
    var name: String
    var company: String
    var phone: String
    var officeAddress: String
    var website: String
}
