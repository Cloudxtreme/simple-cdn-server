# CDN application

- Use nginx
- Use pure-ftpd or ftp ruby
- Use Sinatra


## Example of use

### DNS configuration

*.cdn.my-domain.net CNAME cdn.platform.my-domain.net


### CDN configuration with our app


__For simple CDN__

Just configure for all request go to base of cdn ftp.

__For custom CDN__

Use `*.assets.cdn.my-domain.net` and link it to `assets/` folder.
