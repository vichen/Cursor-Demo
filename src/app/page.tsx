import Link from 'next/link'
import { Button } from '@/components/ui/button'
import { getAllPosts } from '@/lib/api'
import { PostGrid } from '@/components/blog/post-grid'

export default async function HomePage() {
  const posts = await getAllPosts()
  const recentPosts = posts.slice(0, 3) // Get the 3 most recent posts

  return (
    <div className="container mx-auto px-4 py-12">
      <div className="space-y-12">
        {/* Hero Section */}
        <div className="text-center space-y-4">
          <h1 className="text-4xl font-bold tracking-tight sm:text-5xl">
            Welcome to My Blog
          </h1>
          <p className="text-xl text-muted-foreground max-w-2xl mx-auto">
            Exploring technology, development, and everything in between. Read my latest thoughts and insights.
          </p>
          <Button asChild size="lg">
            <Link href="/blog">View All Posts</Link>
          </Button>
        </div>

        {/* Recent Posts Section */}
        <div className="space-y-8">
          <div className="flex items-center justify-between">
            <h2 className="text-2xl font-bold tracking-tight">Recent Posts</h2>
            <Button variant="ghost" asChild>
              <Link href="/blog">View All</Link>
            </Button>
          </div>
          <PostGrid posts={recentPosts} />
        </div>
      </div>
    </div>
  )
}
