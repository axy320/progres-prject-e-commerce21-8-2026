<?php

use App\Http\Controllers\Admin\CategoryController;
use App\Http\Controllers\Admin\InventoryController;
use App\Http\Controllers\Admin\ProductController;
use App\Http\Controllers\Admin\WarehouseController;
use Illuminate\Support\Facades\Route;
use Inertia\Inertia;

// Admin Routes (Protected by auth + staff middleware)
Route::middleware(['auth', 'staff'])->prefix('admin')->name('admin.')->group(function () {
    Route::get('/', fn () => Inertia::render('Admin/Dashboard'))->name('dashboard');

    Route::resource('products', ProductController::class)
        ->except(['show'])
        ->names('products');

    Route::resource('categories', CategoryController::class)
        ->except(['create', 'show', 'edit'])
        ->names('categories');

    // Inventory
    Route::get('inventory', [InventoryController::class, 'index'])
        ->name('inventory.index');
    Route::post('inventory/{inventory}/adjust', [InventoryController::class, 'adjust'])
        ->name('inventory.adjust');

    // Warehouses
    Route::resource('warehouses', WarehouseController::class)
        ->except(['create', 'show', 'edit'])
        ->names('warehouses');
});
