import { getAllPosts } from '@/lib/api'
import { PostGrid } from '@/components/blog/post-grid'

export const metadata = {
  title: 'Blog',
  description: 'Read my latest blog posts',
}

export default async function BlogPage() {
  const posts = await getAllPosts()

  return (
    <div className="container mx-auto px-4 py-12">
      <div className="space-y-8">
        <div className="space-y-2">
          <h1 className="text-3xl font-bold tracking-tight">Blog Posts</h1>
          <p className="text-muted-foreground">Read my latest blog posts</p>
        </div>
        <PostGrid posts={posts} />
      </div>
    </div>
  )
} 