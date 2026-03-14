<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\User;

class UserController extends Controller
{
    // lấy tất cả users
    public function index()
    {
        return User::all();
    }

    // lấy user theo id
    public function show($id)
    {
        return User::find($id);
    }
}