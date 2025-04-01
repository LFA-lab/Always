class PublicPageStrategy < Warden::Strategies::Base
  def valid?
    true
  end

  def authenticate!
    if request.path == '/privacy-policy' || 
       request.path == '/privacy' ||
       request.path == '/about' ||
       request.path == '/contact' ||
       request.path == '/terms' ||
       request.path == '/'
      success!(nil)
    else
      fail!
    end
  end
end

Warden::Strategies.add(:public_page, PublicPageStrategy) 