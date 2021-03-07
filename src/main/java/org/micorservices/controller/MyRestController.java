package org.micorservices.controller;

import org.springframework.http.HttpMethod;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class MyRestController {

    @GetMapping("/healthCheck")
    public String healthCheck() {
        return "Ok";
    }

    @RequestMapping(path = "/", method = RequestMethod.GET)
    public String index() {
        return "Greetings from Spring Boot!!";
    }
}
