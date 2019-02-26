# openssl-patch

## OpenSSL Patch

### This file is not an official OpenSSL patch. Problems can arise and this is your responsibility.

## Original Sources
- [OpenSSL Equal Preference Patch](https://boringssl.googlesource.com/boringssl/+/858a88daf27975f67d9f63e18f95645be2886bfb%5E%21) by [BoringSSL](https://github.com/google/boringssl) & [buik](https://gitlab.com/buik/openssl/blob/openssl-patch/openssl-1.1)
- [HPACK Patch](https://github.com/cloudflare/sslconfig/blob/master/patches/nginx_1.13.1_http2_hpack.patch) by [Cloudflare](https://github.com/cloudflare/sslconfig)
- [nginx Strict-SNI Patch](https://github.com/hakasenyang/openssl-patch/issues/1#issuecomment-421551872) by [@JemmyLoveJenny](https://github.com/JemmyLoveJenny)
- [OpenSSL OLD-CHACHA20-POLY1305](https://github.com/JemmyLoveJenny/ngx_ossl_patches) by [@JemmyLoveJenny](https://github.com/JemmyLoveJenny)

## Information

- [Test Page - (TLS 1.3 final)](https://ssl.hakase.io/)
- [SSL Test Result - testssl.sh](https://ssl.hakase.io/ssltest/hakase.io.html)
- [SSL Test Result - dev.ssllabs.com](https://dev.ssllabs.com/ssltest/analyze.html?d=hakase.io)
- **If you link site to a browser that supports final, you'll see a TLS 1.3 message.**

Displays TLSv1.3 support for large sites.

Default support is in bold type.
- [Baidu(China)](https://baidu.cn/) : **TLSv1.2**
- [Naver(Korea)](https://naver.com/) : **TLSv1.2**
- [Twitter](https://twitter.com/) : **TLSv1.2**
- [**My Site**](https://hakase.io/) : _TLSv1.3_ **final**
- [Facebook](https://facebook.com/) : _TLSv1.3_ draft 23, 26, 28, **final**
- [Cloudflare](https://cloudflare.com/) : _TLSv1.3_ **final**
- [Google(Gmail)](https://gmail.com/) : _TLSv1.3_ **final**
- [NSS TLS 1.3(Mozilla)](https://tls13.crypto.mozilla.org/) : _TLSv1.3_ **final**

[Compatible OpenSSL-3.0.0-dev (OpenSSL, 23425 commits)](https://github.com/openssl/openssl/tree/13d928d38b5ba4f8085cf750bf3fd55685f92a61)

## Patch files

### The equal preference patch(openssl-equal-x) already includes the tls13_draft patch and the tls13_nginx_config(_ciphers file only) patch. Therefore, you do not need to patch it together.

You can find the _OpenSSL 1.1.0h_ patch is [here.](https://gitlab.com/buik/openssl/blob/openssl-patch/openssl-1.1/OpenSSL1.1h-equal-preference-cipher-groups.patch)

Here is the basic patch content.
- BoringSSL's Equal Preference Patch
- Weak 3DES and not using ECDHE ciphers is not used in TLSv1.1 or later.

| Patch file name | Patch list |
| :--- | :--- |
| openssl-equal-1.1.1a.patch<br>openssl-equal-3.0.0-dev.patch | Support **final (TLS 1.3)**, TLS 1.3 cipher settings **_can not_** be changed on _nginx_. |
| openssl-equal-1.1.1a_ciphers.patch<br>openssl-equal-3.0.0-dev_ciphers.patch | Support **final (TLS 1.3)**, TLS 1.3 cipher settings **_can_** be changed on _nginx_. |
| openssl-1.1.1a-chacha_draft.patch<br>openssl-3.0.0-dev-chacha_draft.patch | A draft version of chacha20-poly1305 is available. [View issue](https://github.com/hakasenyang/openssl-patch/issues/1#issuecomment-427554824) |
| openssl-1.1.1a-tls13_draft.patch | Only for **TLS 1.3 draft 23, 26, 28, final support patch**. |
| openssl-1.1.1a-tls13_nginx_config.patch | You can set TLS 1.3 ciphere in nginx. ex) TLS13+AESGCM+AES128 |
| openssl-3.0.0-dev_version_error.patch | **TEST** This is a way to fix nginx when the following errors occur during the build:<br>Error: missing binary operator before token "("<br>Maybe patched: [https://github.com/openssl/openssl/pull/7839](https://github.com/openssl/openssl/pull/7839)<br>Patched : [https://github.com/openssl/openssl/commit/5d609f22d28615c45685d9da871d432e9cb81127](https://github.com/openssl/openssl/commit/5d609f22d28615c45685d9da871d432e9cb81127) |

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
patch -p1 < ../openssl-patch/openssl-equal-3.0.0-dev_ciphers.patch
```

And then use --with-openssl in nginx or build after ./config.

### OpenSSL CHACHA20-POLY1305-OLD Patch

Thanks [@JemmyLoveJenny](https://github.com/JemmyLoveJenny)!

[View issue](https://github.com/hakasenyang/openssl-patch/issues/1#issuecomment-427554824) / [Original Source](https://github.com/JemmyLoveJenny/ngx_ossl_patches/blob/master/ossl_enable_chacha20-poly1305-draft.patch)

```
git clone https://github.com/openssl/openssl.git
git clone https://github.com/hakasenyang/openssl-patch.git
cd openssl
patch -p1 < ../openssl-patch/openssl-1.1.1a-chacha_draft.patch
```

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

This is a condition for using strict sni. [View issue.](https://github.com/hakasenyang/openssl-patch/issues/7#issuecomment-427664716)

- How to use nginx strict-sni?
    - **ONLY USE IN http { }**
    - strict_sni : nginx strict-sni ON/OFF toggle option.
    - strict_sni_header : if you do not want to respond to invalid headers. (**only with strict_sni**)
    - Strict SNI requires at least two ssl server (fake) settings (server { listen 443 ssl }).
    - It does not matter what kind of certificate or duplicate.

Thanks [@JemmyLoveJenny](https://github.com/hakasenyang/openssl-patch/issues/1#issuecomment-427040319), [@NewBugger](https://github.com/hakasenyang/openssl-patch/issues/7#issuecomment-427831677)!

### nginx OpenSSL-1.1.x Renegotiation Bugfix

It has already been patched by nginx >= 1.15.4.

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

### OpenSSL-1.1.1a, 3.0.0-dev ciphers
```
[EECDH+ECDSA+AESGCM+AES128|EECDH+ECDSA+CHACHA20]:EECDH+ECDSA+AESGCM+AES256:EECDH+ECDSA+AES128+SHA:EECDH+ECDSA+AES256+SHA:[EECDH+aRSA+AESGCM+AES128|EECDH+aRSA+CHACHA20]:EECDH+aRSA+AESGCM+AES256:EECDH+aRSA+AES128+SHA:EECDH+aRSA+AES256+SHA:RSA+AES128+SHA:RSA+AES256+SHA:RSA+3DES
```

### OpenSSL-1.1.1a_ciphers, 3.0.0-dev_ciphers ciphers
```
[TLS13+AESGCM+AES128|TLS13+AESGCM+AES256|TLS13+CHACHA20]:[EECDH+ECDSA+AESGCM+AES128|EECDH+ECDSA+CHACHA20]:EECDH+ECDSA+AESGCM+AES256:EECDH+ECDSA+AES128+SHA:EECDH+ECDSA+AES256+SHA:[EECDH+aRSA+AESGCM+AES128|EECDH+aRSA+CHACHA20]:EECDH+aRSA+AESGCM+AES256:EECDH+aRSA+AES128+SHA:EECDH+aRSA+AES256+SHA:RSA+AES128+SHA:RSA+AES256+SHA:RSA+3DES
```
