import Link from 'next/link'
import { Button } from '@/components/ui/button'

export default function NotFound() {
  return (
    <div className="container mx-auto px-4 py-12">
      <div className="max-w-xl mx-auto text-center space-y-4">
        <h1 className="text-4xl font-bold">404 - Post Not Found</h1>
        <p className="text-muted-foreground">
          Sorry, the blog post you're looking for doesn't exist or has been removed.
        </p>
        <Button asChild>
          <Link href="/blog">Back to Blog</Link>
        </Button>
      </div>
    </div>
  )
} 