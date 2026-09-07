<?php

namespace App\Domain\Catalog\Actions;

use App\Models\Category;

final class CreateCategoryAction
{
    use ResolvesCategorySlug;

    /**
     * @param  array<string, mixed>  $data
     */
    public function execute(array $data): Category
    {
        return Category::create([
            'parent_id' => $data['parent_id'] ?? null,
            'name' => $data['name'],
            'slug' => $this->resolveSlug($data),
            'status' => $data['status'] ?? 'draft',
            'sort_order' => (int) ($data['sort_order'] ?? 0),
            'meta_title' => $data['meta_title'] ?? null,
            'meta_description' => $data['meta_description'] ?? null,
        ]);
    }
}