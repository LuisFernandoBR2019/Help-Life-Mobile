import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:helplifeandroid/entity/tipoSanguineo.dart';
import 'package:helplifeandroid/entity/usuario.dart';
import 'package:http/http.dart' as http;

const _request = "http://192.168.0.101:9030/api/v1/helplife/hemocentro";