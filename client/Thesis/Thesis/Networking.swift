//
//  Networking.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 10/17/15.
//  Copyright © 2015 Erin Bleiweiss. All rights reserved.
//

class Networking {
    var hostname: String = "http://thesis-loadbalancer-157482704.us-west-2.elb.amazonaws.com"
    var rest_prefix: String = "/v1"
    
    static let networkConfig = Networking()
}