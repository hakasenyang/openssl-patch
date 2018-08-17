# openssl-patch

## OpenSSL Equal Preference Patch

### This file is not an official OpenSSL patch. Problems can arise and this is your responsibility.

## Original Sources
- [OpenSSL Equal Preference Patch](https://boringssl.googlesource.com/boringssl/+/858a88daf27975f67d9f63e18f95645be2886bfb%5E%21) by [BoringSSL](https://github.com/google/boringssl) & [buik](https://gitlab.com/buik/openssl/blob/openssl-patch/openssl-1.1)
- [HPACK Patch](https://github.com/cloudflare/sslconfig/blob/master/patches/nginx_1.13.1_http2_hpack.patch) by [Cloudflare](https://github.com/cloudflare/sslconfig)

## Information

- [Test Page - (TLS 1.3 draft 23, 26, 28, final)](https://ssl.hakase.io/)
- [SSL Test Result - testssl.sh](https://ssl.hakase.io/ssltest/hakase.io.html)
- [SSL Test Result - dev.ssllabs.com](https://dev.ssllabs.com/ssltest/analyze.html?d=hakase.io)
- **If you link site to a browser that supports draft 23 or 26 or 28 or final, you'll see a TLS 1.3 message.**

**Support TLS 1.3 draft 28 browsers - _Chrome Canary, Firefox Nightly_**

Displays TLSv1.3 support for large sites.
Default support is in bold type.
- Baidu(China) : **TLSv1.2**
- Naver(Korea) : **TLSv1.2**
- Twitter : **TLSv1.2**
- **My Site** : _TLSv1.3_ draft 23, 26, 28, **final**
- Facebook : _TLSv1.3_ draft 23, 26, 28, **final**
- Google(Gmail) : _TLSv1.3_ draft 23, **28**
- Cloudflare : _TLSv1.3_ draft **23**, 28

[Compatible OpenSSL-1.1.1-pre9-dev (OpenSSL, 22644 commits)](https://github.com/openssl/openssl/tree/2805ee1e095a78f596dc7adf778441e2edb9f15c)

## Patch files

You can find the _OpenSSL 1.1.0h_ patch is [here.](https://gitlab.com/buik/openssl/blob/openssl-patch/openssl-1.1/OpenSSL1.1h-equal-preference-cipher-groups.patch)

Here is the basic patch content.
- Support TLS 1.3 draft 23 + 26 + 28 **(Pre9) + final** (Not support pre2 - 26, 28, final)
    - Server: draft 23 + 26 + 28
    - Client: draft 23 + 26 + 27 + 28
    - (pre9)Server: draft 23 + 26 + 28 + final
    - (pre9)Client: draft 23 + 26 + 27 + 28 + final
- BoringSSL's Equal Preference Patch
- Weak 3DES and not using ECDHE ciphers is not used in TLSv1.1 or later.

| Patch file name | Patch list |
| :--- | :--- |
| openssl-equal-pre2.patch | **_Not support_** draft **26, 28**. |
| openssl-equal-pre7.patch<br />openssl-equal-pre8.patch | TLS 1.3 cipher settings **_can not_** be changed on _nginx_. |
| openssl-equal-pre7_ciphers.patch<br />openssl-equal-pre8_ciphers.patch | TLS 1.3 cipher settings **_can_** be changed on _nginx_. |
| openssl-equal-pre9.patch | Support **final (TLS 1.3)**, TLS 1.3 cipher settings **_can not_** be changed on _nginx_. |
| openssl-equal-pre9_ciphers.patch | Support **final (TLS 1.3)**, TLS 1.3 cipher settings **_can_** be changed on _nginx_. |

**The "_ciphers" patch file is a temporary change to the TLS 1.3 configuration.**

Example of setting TLS 1.3 cipher in nginx (pre7 or higher):

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

## How To Use?

### OpenSSL Patch

```
git clone https://github.com/openssl/openssl.git
git clone https://github.com/hakasenyang/openssl-patch.git
cd openssl
patch -p1 < ../openssl-patch/openssl-equal-pre9_ciphers.patch
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

### OpenSSL-1.1.1-pre2 ciphers (draft 23)
```
[TLS13-AES-128-GCM-SHA256|TLS13-AES-256-GCM-SHA384|TLS13-CHACHA20-POLY1305-SHA256]:[EECDH+ECDSA+AESGCM+AES128|EECDH+ECDSA+CHACHA20]:EECDH+ECDSA+AESGCM+AES256:EECDH+ECDSA+AES128+SHA:EECDH+ECDSA+AES256+SHA:[EECDH+aRSA+AESGCM+AES128|EECDH+aRSA+CHACHA20]:EECDH+aRSA+AESGCM+AES256:EECDH+aRSA+AES128+SHA:EECDH+aRSA+AES256+SHA:RSA+AES128+SHA:RSA+AES256+SHA:RSA+3DES
```

### OpenSSL-1.1.1-pre7~9 ciphers (draft 23, 26, 28, **(pre9) - final**)
```
[EECDH+ECDSA+AESGCM+AES128|EECDH+ECDSA+CHACHA20]:EECDH+ECDSA+AESGCM+AES256:EECDH+ECDSA+AES128+SHA:EECDH+ECDSA+AES256+SHA:[EECDH+aRSA+AESGCM+AES128|EECDH+aRSA+CHACHA20]:EECDH+aRSA+AESGCM+AES256:EECDH+aRSA+AES128+SHA:EECDH+aRSA+AES256+SHA:RSA+AES128+SHA:RSA+AES256+SHA:RSA+3DES
```

### OpenSSL-1.1.1-pre7~9_ciphers ciphers (draft 23, 26, 28, **(pre9) - final**)
```
[TLS13+AESGCM+AES128|TLS13+AESGCM+AES256|TLS13+CHACHA20]:[EECDH+ECDSA+AESGCM+AES128|EECDH+ECDSA+CHACHA20]:EECDH+ECDSA+AESGCM+AES256:EECDH+ECDSA+AES128+SHA:EECDH+ECDSA+AES256+SHA:[EECDH+aRSA+AESGCM+AES128|EECDH+aRSA+CHACHA20]:EECDH+aRSA+AESGCM+AES256:EECDH+aRSA+AES128+SHA:EECDH+aRSA+AES256+SHA:RSA+AES128+SHA:RSA+AES256+SHA:RSA+3DES
```
