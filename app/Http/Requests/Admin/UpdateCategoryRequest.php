<?php

namespace App\Http\Requests\Admin;

use App\Models\Category;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class UpdateCategoryRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    /**
     * @return array<string, mixed>
     */
    public function rules(): array
    {
        return [
            'name' => ['required', 'string', 'max:150'],
            'slug' => ['nullable', 'string', 'max:170', Rule::unique('categories', 'slug')->ignore($this->category())],
            'parent_id' => ['nullable', 'integer', 'exists:categories,id'],
            'status' => ['required', 'string', 'in:draft,published,archived'],
            'sort_order' => ['nullable', 'integer', 'min:0'],
            'meta_title' => ['nullable', 'string', 'max:255'],
            'meta_description' => ['nullable', 'string', 'max:500'],
        ];
    }

    private function category(): ?Category
    {
        $routeParam = $this->route('category');

        return $routeParam instanceof Category ? $routeParam : null;
    }

    /**
     * @return array<string, string>
     */
    public function messages(): array
    {
        return [
            'name.required' => 'Nama kategori wajib diisi.',
            'slug.unique' => 'Slug sudah dipakai kategori lain.',
            'parent_id.exists' => 'Kategori induk tidak valid.',
            'status.in' => 'Status harus draft, published, atau archived.',
            'sort_order.min' => 'Urutan tidak boleh negatif.',
        ];
    }
}