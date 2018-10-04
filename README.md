# openssl-patch

## OpenSSL Equal Preference Patch

### This file is not an official OpenSSL patch. Problems can arise and this is your responsibility.

## Original Sources
- [OpenSSL Equal Preference Patch](https://boringssl.googlesource.com/boringssl/+/858a88daf27975f67d9f63e18f95645be2886bfb%5E%21) by [BoringSSL](https://github.com/google/boringssl) & [buik](https://gitlab.com/buik/openssl/blob/openssl-patch/openssl-1.1)
- [HPACK Patch](https://github.com/cloudflare/sslconfig/blob/master/patches/nginx_1.13.1_http2_hpack.patch) by [Cloudflare](https://github.com/cloudflare/sslconfig)
- [nginx Strict-SNI Patch](https://github.com/hakasenyang/openssl-patch/issues/1#issuecomment-421551872) by [@JemmyLoveJenny](https://github.com/JemmyLoveJenny)

## Information

- [Test Page - (TLS 1.3 draft 23, 26, 28, final)](https://ssl.hakase.io/)
- [SSL Test Result - testssl.sh](https://ssl.hakase.io/ssltest/hakase.io.html)
- [SSL Test Result - dev.ssllabs.com](https://dev.ssllabs.com/ssltest/analyze.html?d=hakase.io)
- **If you link site to a browser that supports draft 23 or 26 or 28 or final, you'll see a TLS 1.3 message.**

**Support TLS 1.3 draft 28 browsers - _Chrome Canary, Firefox Nightly_**

Displays TLSv1.3 support for large sites.

Default support is in bold type.
- [Baidu(China)](https://baidu.cn/) : **TLSv1.2**
- [Naver(Korea)](https://naver.com/) : **TLSv1.2**
- [Twitter](https://twitter.com/) : **TLSv1.2**
- [**My Site**](https://hakase.io/) : _TLSv1.3_ draft 23, 26, 28, **final**
- [Facebook](https://facebook.com/) : _TLSv1.3_ draft 23, 26, 28, **final**
- [Cloudflare](https://cloudflare.com/) : _TLSv1.3_ draft 23, 28, **final**
- [Google(Gmail)](https://gmail.com/) : _TLSv1.3_ draft 23, 28, **final**
- [NSS TLS 1.3(Mozilla)](https://tls13.crypto.mozilla.org/) : _TLSv1.3_ **final**

[Compatible OpenSSL-1.1.1 (OpenSSL, 22764 commits)](https://github.com/openssl/openssl/tree/1708e3e85b4a86bae26860aa5d2913fc8eff6086)

## Patch files

You can find the _OpenSSL 1.1.0h_ patch is [here.](https://gitlab.com/buik/openssl/blob/openssl-patch/openssl-1.1/OpenSSL1.1h-equal-preference-cipher-groups.patch)

Here is the basic patch content.
- Support TLS 1.3 draft 23 + 26 + 28 + final
    - Server: draft 23 + 26 + 28 + final
    - Client: draft 23 + 26 + 27 + 28 + final
- BoringSSL's Equal Preference Patch
- Weak 3DES and not using ECDHE ciphers is not used in TLSv1.1 or later.

| Patch file name | Patch list |
| :--- | :--- |
| openssl-equal-1.1.1.patch<br>openssl-equal-1.1.2-dev.patch | Support **final (TLS 1.3)**, TLS 1.3 cipher settings **_can not_** be changed on _nginx_. |
| openssl-equal-1.1.1_ciphers.patch<br>openssl-equal-1.1.2-dev_ciphers.patch | Support **final (TLS 1.3)**, TLS 1.3 cipher settings **_can_** be changed on _nginx_. |
| openssl-ignore_log_strict-sni.patch | When using nginx_strict-sni.patch, nginx ignores the error in error.log. [View issue](https://github.com/hakasenyang/openssl-patch/issues/1#issuecomment-421594901) |

**The "_ciphers" patch file is a temporary change to the TLS 1.3 configuration.**

Example of setting TLS 1.3 cipher in nginx:

| Example | Ciphers |
| :--- | :--- |
| Short Cipher |  TLS13+AESGCM+AES128:TLS13+AESGCM+AES256:TLS13+CHACHA20 |
| Fullname Cipher | TLS_AES_128_GCM_SHA256:TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256 |
| TLS 1.3 + 1.2 ciphers | TLS13+AESGCM+AES128:EECDH+AES128 |

## Not OpenSSL patch files

| Patch file name | Patch list |
| :--- | :--- |
| nginx_hpack_push.patch | _Patch both_ the HPACK patch and the **PUSH ERROR**. |
| nginx_hpack_push_fix.patch | _Patch only_ the **PUSH ERROR** of the hpack patch. (If the HPACK patch has already been completed) |
| remove_nginx_server_header.patch | Remove nginx server header. (http2, http1.1) |
| nginx_hpack_remove_server_header_1.15.3.patch | HPACK + Remove nginx server header. (http2, http1.1) |
| nginx_strict-sni.patch | Enable **Strict-SNI**. Thanks [@JemmyLoveJenny](https://github.com/JemmyLoveJenny). [View issue](https://github.com/hakasenyang/openssl-patch/issues/1#issuecomment-421551872) |
| nginx_openssl-1.1.x_renegotiation_bugfix.patch | Bugfix **Secure Client-Initiated Renegotiation**. (Check testssl.sh) OpenSSL >= 1.1.x, nginx = 1.15.4<br>[Patched nginx 1.15.5](https://github.com/nginx/nginx/commit/53803b4780be15d8014be183d4161091fd5f3376) |

## How To Use?

### OpenSSL Patch

```
git clone https://github.com/openssl/openssl.git
git clone https://github.com/hakasenyang/openssl-patch.git
cd openssl
patch -p1 < ../openssl-patch/openssl-equal-1.1.2-dev_ciphers.patch
```

And then use --with-openssl in nginx or build after ./config.

### nginx HPACK Patch

Run it from the nginx directory.

If you **have a** PUSH patch, use it as follows.

``curl https://raw.githubusercontent.com/hakasenyang/openssl-patch/master/nginx_hpack_push_fix.patch | patch -p1 ``

If you **did not** patch PUSH, use it as follows.

``curl https://raw.githubusercontent.com/hakasenyang/openssl-patch/master/nginx_hpack_push.patch | patch -p1``

And then check the nginx configuration below.

### nginx Remove Server Header Patch

Run it from the nginx directory.

``curl https://raw.githubusercontent.com/hakasenyang/openssl-patch/master/remove_nginx_server_header.patch | patch -p1``

### nginx strict-sni patch

Run it from the nginx directory.

``curl https://raw.githubusercontent.com/hakasenyang/openssl-patch/master/nginx_strict-sni.patch | patch -p1``

Thanks [@JemmyLoveJenny](https://github.com/hakasenyang/openssl-patch/issues/1#issuecomment-427040319)!

### nginx OpenSSL-1.1.x Renegotiation Bugfix

Run it from the nginx directory.

``curl https://raw.githubusercontent.com/hakasenyang/openssl-patch/master/nginx_openssl-1.1.x_renegotiation_bugfix.patch | patch -p1``

## nginx Configuration

### HPACK Patch

Add configure arguments : ``--with-http_v2_hpack_enc``

### SSL Setting
```
ssl_protocols TLSv1 TLSv1.1 TLSv1.2 TLSv1.3;
ssl_ciphers [Copy it from below and paste it here.];
ssl_ecdh_curve X25519:P-256:P-384;
ssl_prefer_server_ciphers on;
```

### OpenSSL-1.1.x (> 1.1.1) ciphers (draft 23, 26, 28, final)
```
[EECDH+ECDSA+AESGCM+AES128|EECDH+ECDSA+CHACHA20]:EECDH+ECDSA+AESGCM+AES256:EECDH+ECDSA+AES128+SHA:EECDH+ECDSA+AES256+SHA:[EECDH+aRSA+AESGCM+AES128|EECDH+aRSA+CHACHA20]:EECDH+aRSA+AESGCM+AES256:EECDH+aRSA+AES128+SHA:EECDH+aRSA+AES256+SHA:RSA+AES128+SHA:RSA+AES256+SHA:RSA+3DES
```

### OpenSSL-1.1.x_ciphers (> 1.1.1) ciphers (draft 23, 26, 28, final)
```
[TLS13+AESGCM+AES128|TLS13+AESGCM+AES256|TLS13+CHACHA20]:[EECDH+ECDSA+AESGCM+AES128|EECDH+ECDSA+CHACHA20]:EECDH+ECDSA+AESGCM+AES256:EECDH+ECDSA+AES128+SHA:EECDH+ECDSA+AES256+SHA:[EECDH+aRSA+AESGCM+AES128|EECDH+aRSA+CHACHA20]:EECDH+aRSA+AESGCM+AES256:EECDH+aRSA+AES128+SHA:EECDH+aRSA+AES256+SHA:RSA+AES128+SHA:RSA+AES256+SHA:RSA+3DES
```
