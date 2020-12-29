<?php

namespace Tests\Feature\Controller;

use App\Models\Category;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class CategoryControllerTest extends TestCase
{
    use RefreshDatabase;

    /**
     * A basic test example.
     *
     * @return void
     */
    public function testItLoadsThePageWithCategories()
    {
        // create 3 test categories
        $categories = Category::factory(3)->create();
        $response = $this->get('/categories');

        $response->assertStatus(200);
        foreach ($categories as $category) {
            $response->assertSee($category->name);
        }
    }
}
