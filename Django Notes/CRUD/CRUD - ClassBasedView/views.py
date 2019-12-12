from django.shortcuts import render, get_object_or_404, redirect
from .models import BlogPost
from django.views.generic import ListView, DetailView, CreateView, UpdateView, DeleteView
from .forms import BlogForm


class PostListView(ListView):
    model = BlogPost
    template_name = "blogs/home.html"


class PostDetailView(DetailView):
    model = BlogPost
    template_name = 'blogs/blog-detail.html'

    def get_object(self):
        slug = self.kwargs.get('title_slug')
        return get_object_or_404(BlogPost, slug=slug)


class PostCreateView(CreateView):
    model = BlogPost
    template_name = 'blogs/blog-form.html'
    fields = [
        'title',
        'content',
        'image'
    ]


class PostUpdateView(UpdateView, LoginRequiredMixin, UserPassesTestMixin):
    model = BlogPost
    template_name = 'blogs/blog-update.html'
    fields = [
        'title',
        'content',
        'image'
    ]

    def form_valid(self, form):
        form.instance.author = self.request.user
        return super().form_valid(form)

    def test_func(self):
        post = self.get_object()
        if post.author == self.request.user:
            return True
        return False

    def get_object(self):
        slug = self.kwargs.get('title_slug')
        return get_object_or_404(BlogPost, slug=slug)


class PostDeleteView(DeleteView):
    model = BlogPost
    template_name = 'blogs/blog-delete.html'
    success_url = "/"

    def get_object(self):
        slug = self.kwargs.get('title_slug')
        return get_object_or_404(BlogPost, slug=slug)
