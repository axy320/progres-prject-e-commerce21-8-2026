<?php

namespace App\Http\Middleware;

use Illuminate\Http\Request;
use Inertia\Inertia;
use Symfony\Component\HttpFoundation\Response;

class HandleInertiaRequests extends \Inertia\Middleware
{
    public function share(Request $request): array
    {
        return [
            ...parent::share($request),
            'auth' => [
                'user' => fn () => $request->user()?->load('roles'),
            ],
            'flash' => fn () => [
                'success' => $request->session()->get('success'),
            ],
        ];
    }
}
