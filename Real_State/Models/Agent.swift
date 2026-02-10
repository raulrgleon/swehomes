//
//  Agent.swift
//  Real_State
//
//  Modelo del agente inmobiliario.
//

import Foundation

struct Agent: Identifiable {
    let id: UUID
    var name: String
    var rating: Double
    var reviewCount: Int
    var company: String
    var phone: String
    var email: String
}
