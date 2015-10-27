<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class KegeratorController extends Controller {

    public function kegeratorMainDisplay(Request $request) {

        return view('kegerator.main');

    }

}

