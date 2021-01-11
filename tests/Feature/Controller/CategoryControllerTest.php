<?php

namespace Tests\Feature\Controller;

use App\Models\Category;
use Faker\Generator as Faker;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class CategoryControllerTest extends TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();
    }

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

    public function testItValidatesTheCategoryWhenUpdating()
    {
        // create a category
        $category = Category::factory()->create();
        // attempt to update with no name
        $this->patchJson('/categories/' . $category->id, [])
            ->assertStatus(422)
            ->assertJsonFragment(['name' => ['The name field is required.']]);
    }

    public function testItRequiresTheNameToBeOverAMinimumNumberOfCharacters()
    {
        // create a category
        $category = Category::factory()->create();
        // attempt to update with too short of a name
        $this->patchJson('/categories/' . $category->id, ['name' => 'a'])
            ->assertStatus(422)
            ->assertJsonFragment(['name' => ['The name must be at least 2 characters.']]);
    }

    public function testItRequiresTheNameToBeUnderAMaximumNumberOfCharacters()
    {
        // create a category
        $category = Category::factory()->create();
        // attempt to update with too long of a name
        $this->patchJson('/categories/' . $category->id, ['name' => str_repeat('a', 2000)])
            ->assertStatus(422)
            ->assertJsonFragment(['name' => ['The name may not be greater than 128 characters.']]);
    }

    public function testItUpdatesACategoryWithValidData()
    {
        // create a category
        $category = Category::factory()->create();
        // perform the update
        $response = $this->patchJson('/categories/' . $category->id, ['name' => 'ABCDE']);
        // A successful update should return a redirect
        $response->assertRedirect(url('categories'));
        // Check that it is updated in the database
        $this->assertDatabaseHas('categories', ['id' => $category->id, 'name' => 'ABCDE']);
    }
}
