<?php

namespace App\Domain\Catalog\Actions;

use App\Models\Product;
use App\Models\ProductImage;
use App\Models\ProductVariant;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;

final class DeleteProductAction
{
    public function execute(Product $product): void
    {
        DB::transaction(function () use ($product) {
            $paths = $product->images()->pluck('path')->filter()->values();

            // Hapus varian secara permanen (bukan soft delete) beserta stok
            // inventory-nya, supaya produk yang sudah dihapus tidak lagi
            // meninggalkan baris inventory "yatim" di halaman Inventory.
            // inventories.variant_id punya ON DELETE CASCADE, sehingga baris
            // inventory otomatis terhapus saat varian dihapus permanen.
            $variantIds = $product->variants()->withTrashed()->pluck('id');
            ProductVariant::withTrashed()->whereIn('id', $variantIds)->forceDelete();

            $product->images()->delete();

            // Produk soft-delete agar alur arsip tetap tersedia (konsisten
            // dengan perilaku SoftDeletes yang sudah dipakai sebelumnya).
            $product->delete();

            foreach ($paths as $path) {
                Storage::disk('public')->delete($path);
            }
        });
    }
}
