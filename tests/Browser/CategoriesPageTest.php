<?php

namespace Tests\Browser;

use App\Models\Category;
use Illuminate\Foundation\Testing\DatabaseMigrations;
use Laravel\Dusk\Browser;
use Tests\DuskTestCase;

class CategoriesPageTest extends DuskTestCase
{
    use DatabaseMigrations;

    public function testItListsExistingCategories()
    {
        $categories = Category::factory(3)->create();

        $this->browse(function (Browser $browser) use ($categories) {
            $browser->visit('/categories')
                ->assertSee('Categories')
                ->assertSee($categories[0]->name)
                ->assertSee($categories[1]->name)
                ->assertSee($categories[2]->name);
        });
    }
}
