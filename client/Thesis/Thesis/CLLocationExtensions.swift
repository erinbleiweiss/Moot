//
//  CLLocationExtensions.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 3/31/16.
//  Copyright © 2016 Erin Bleiweiss. All rights reserved.
//

import Foundation
import CoreLocation

let kPi = 3.141592653589793

func degreesToRadians(degrees: Double) -> Double {
    return degrees * M_PI / 180.0 as Double
}

func radiansToDegrees(radians: Double) -> Double {
    return radians * 180.0 / M_PI as Double
}

extension CLLocation {
    func bearingInRadiansTowardsLocation(towardsLocation: CLLocation) -> Double {
        // calculate the bearing in the direction of towardsLocation from this location's coordinate
        // Formula:	θ =	atan2(sin(Δlong).cos(lat2), cos(lat1).sin(lat2) − sin(lat1).cos(lat2).cos(Δlong))
        // Based on the formula as described at http://www.movable-type.co.uk/scripts/latlong.html
        // original JavaScript implementation © 2002-2006 Chris Veness
        let lat1: Double = degreesToRadians(self.coordinate.latitude)
        let lon1: Double = degreesToRadians(self.coordinate.longitude)
        let lat2: Double = degreesToRadians(towardsLocation.coordinate.latitude)
        let lon2: Double = degreesToRadians(towardsLocation.coordinate.longitude)
        let dLon: Double = lon2 - lon1
        let y: Double = sin(dLon) * cos(lat2)
        let x: Double = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        var bearing: Double = atan2(y, x) + (2 * kPi)
        // atan2 works on a range of -π to 0 to π, so add on 2π and perform a modulo check
        if bearing > (2 * kPi) {
            bearing = bearing - (2 * kPi)
        }
        return bearing
    }
    
    func newLocationAtDistance(atDistance: CLLocationDistance, alongBearingInRadians bearingInRadians: Double) -> CLLocation {
        // calculate an endpoint given a startpoint, bearing and distance
        // Vincenty 'Direct' formula based on the formula as described at http://www.movable-type.co.uk/scripts/latlong-vincenty-direct.html
        // original JavaScript implementation © 2002-2006 Chris Veness
        let lat1: Double = degreesToRadians(self.coordinate.latitude)
        let lon1: Double = degreesToRadians(self.coordinate.longitude)
        let a: Double = 6378137
        let b: Double = 6356752.3142
        let f: Double = 1 / 298.257223563
        // WGS-84 ellipsiod
        let s: Double = atDistance
        let alpha1: Double = bearingInRadians
        let sinAlpha1: Double = sin(alpha1)
        let cosAlpha1: Double = cos(alpha1)
        let tanU1: Double = (1 - f) * tan(lat1)
        let cosU1: Double = 1 / sqrt((1 + tanU1 * tanU1))
        let sinU1: Double = tanU1 * cosU1
        let sigma1: Double = atan2(tanU1, cosAlpha1)
        let sinAlpha: Double = cosU1 * sinAlpha1
        let cosSqAlpha: Double = 1 - sinAlpha * sinAlpha
        let uSq: Double = cosSqAlpha * (a * a - b * b) / (b * b)
        let A: Double = 1 + uSq / 16384 * (4096 + uSq * (-768 + uSq * (320 - 175 * uSq)))
        let B: Double = uSq / 1024 * (256 + uSq * (-128 + uSq * (74 - 47 * uSq)))
        var sigma: Double = s / (b * A)
        var sigmaP: Double = 2 * kPi
        var cos2SigmaM: Double?
        var sinSigma: Double?
        var cosSigma: Double?
        while abs(sigma - sigmaP) > 1e-12 {
            cos2SigmaM = cos(2 * sigma1 + sigma)
            sinSigma = sin(sigma)
            cosSigma = cos(sigma)
            let AA = (-1 + 2 * cos2SigmaM! * cos2SigmaM!)
            let BB = (-3 + 4 * sinSigma! * sinSigma!)
            let CC = (-3 + 4 * cos2SigmaM! * cos2SigmaM!)
            let innerProduct = (cosSigma! * AA - B / 6 * cos2SigmaM! * BB * CC)
            let deltaSigma: Double = B * sinSigma! * (cos2SigmaM! + B / 4 * innerProduct)
            sigmaP = sigma
            sigma = s / (b * A) + deltaSigma
        }
        let tmp: Double = sinU1 * sinSigma! - cosU1 * cosSigma! * cosAlpha1
        let lat2: Double = atan2(sinU1 * cosSigma! + cosU1 * sinSigma! * cosAlpha1, (1 - f) * sqrt(sinAlpha * sinAlpha + tmp * tmp))
        let lambda: Double = atan2(sinSigma! * sinAlpha1, cosU1 * cosSigma! - sinU1 * sinSigma! * cosAlpha1)
        let C: Double = f / 16 * cosSqAlpha * (4 + f * (4 - 3 * cosSqAlpha))
        let innerProduct2 = (cos2SigmaM! + C * cosSigma! * (-1 + 2 * cos2SigmaM! * cos2SigmaM!))
        let L: Double = lambda - (1 - C) * f * sinAlpha * (sigma + C * sinSigma! * innerProduct2)
        let lon2: Double = lon1 + L
        // create a new CLLocation for this point
        let edgePoint: CLLocation = CLLocation(latitude: radiansToDegrees(lat2), longitude: radiansToDegrees(lon2))
        return edgePoint
    }
    
    func newLocationAtDistance(atDistance: CLLocationDistance, towardsLocation: CLLocation) -> CLLocation {
        let bearingInRadians: Double = self.bearingInRadiansTowardsLocation(towardsLocation)
        return self.newLocationAtDistance(atDistance, alongBearingInRadians: bearingInRadians)
    }
}