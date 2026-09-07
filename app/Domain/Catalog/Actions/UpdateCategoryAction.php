<?php

namespace App\Domain\Catalog\Actions;

use App\Models\Category;

final class UpdateCategoryAction
{
    use ResolvesCategorySlug;

    /**
     * @param  array<string, mixed>  $data
     */
    public function execute(Category $category, array $data): Category
    {
        $parentId = $data['parent_id'] ?? null;

        // Cegah sebuah kategori menjadi induk dari dirinya sendiri.
        if ((int) $parentId === $category->id) {
            $parentId = $category->getOriginal('parent_id');
        }

        $category->update([
            'parent_id' => $parentId !== null ? (int) $parentId : null,
            'name' => $data['name'],
            'slug' => $this->resolveSlug($data, $category),
            'status' => $data['status'] ?? $category->status,
            'sort_order' => (int) ($data['sort_order'] ?? 0),
            'meta_title' => $data['meta_title'] ?? null,
            'meta_description' => $data['meta_description'] ?? null,
        ]);

        return $category->refresh();
    }
}