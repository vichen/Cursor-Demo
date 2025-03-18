import Image from 'next/image'
import { Badge } from '@/components/ui/badge'
import { Post } from '@/lib/api'

interface PostHeaderProps {
  post: Post
}

export function PostHeader({ post }: PostHeaderProps) {
  return (
    <div className="space-y-6">
      <div className="space-y-2">
        {post.categories && (
          <Badge variant="outline">{post.categories.name}</Badge>
        )}
        <h1 className="text-3xl md:text-4xl font-bold tracking-tight">
          {post.title}
        </h1>
        <p className="text-muted-foreground">
          {new Date(post.created_at).toLocaleDateString('en-US', {
            weekday: 'long',
            month: 'long',
            day: 'numeric',
            year: 'numeric',
          })}
        </p>
      </div>
      {post.featured_image && (
        <div className="aspect-video relative rounded-lg overflow-hidden">
          <Image
            src={post.featured_image}
            alt={post.title}
            fill
            className="object-cover"
            priority
            sizes="(max-width: 768px) 100vw, 1200px"
          />
        </div>
      )}
    </div>
  )
} 