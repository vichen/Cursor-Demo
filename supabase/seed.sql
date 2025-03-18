-- Insert categories
INSERT INTO categories (name, slug) VALUES
('Technology', 'technology'),
('Personal', 'personal'),
('Projects', 'projects');

-- Insert sample blog posts
INSERT INTO posts (
  title,
  slug,
  content,
  excerpt,
  category_id,
  published,
  published_at,
  updated_at
) VALUES (
  'Getting Started with Next.js and Supabase',
  'getting-started-with-nextjs-and-supabase',
  E'# Getting Started with Next.js and Supabase\n\nNext.js and Supabase make a powerful combination for building modern web applications. In this post, I''ll share my experience setting up a blog with these technologies.\n\n## Why Next.js?\n\nNext.js offers several advantages:\n\n- **Server-Side Rendering (SSR)** - Great for SEO\n- **Static Site Generation (SSG)** - Fast page loads\n- **API Routes** - Backend functionality without a separate server\n- **Built-in Image Optimization** - Faster page loads and better UX\n\n## Why Supabase?\n\nSupabase provides:\n\n- **PostgreSQL Database** - Powerful and reliable\n- **Authentication** - Easy to implement\n- **Storage** - For images and other files\n- **Realtime** - For live updates',
  'Learn how to combine Next.js and Supabase to create a powerful and flexible blog application with server-side rendering and a PostgreSQL database.',
  (SELECT id FROM categories WHERE slug = 'technology'),
  true,
  now(),
  now()
);

INSERT INTO posts (
  title,
  slug,
  content,
  excerpt,
  category_id,
  published,
  published_at,
  updated_at
) VALUES (
  'Creating a Responsive UI with Tailwind CSS',
  'creating-responsive-ui-with-tailwind-css',
  E'# Creating a Responsive UI with Tailwind CSS\n\nTailwind CSS has revolutionized the way I approach frontend development. In this post, I''ll share some tips on creating responsive designs with Tailwind.\n\n## Why Tailwind CSS?\n\nTailwind offers several advantages:\n\n- **Utility-First** - Build custom designs without leaving your HTML\n- **Responsive Design** - Built-in responsive modifiers\n- **Dark Mode** - Easy dark mode implementation\n- **Customization** - Tailor the framework to your needs',
  'Discover how to build responsive user interfaces using Tailwind CSS, a utility-first CSS framework that makes it easy to create custom designs.',
  (SELECT id FROM categories WHERE slug = 'technology'),
  true,
  now(),
  now()
); 