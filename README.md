# openssl-patch

## OpenSSL Equal Preference Patch

### This file is not an official OpenSSL patch. Problems can arise and this is your responsibility.

## Original Sources
- [OpenSSL Equal Preference Patch](https://boringssl.googlesource.com/boringssl/+/858a88daf27975f67d9f63e18f95645be2886bfb%5E%21) by [BoringSSL](https://github.com/google/boringssl) & [buik](https://gitlab.com/buik/openssl/blob/openssl-patch/openssl-1.1)
- [HPACK Patch](https://github.com/cloudflare/sslconfig/blob/master/patches/nginx_1.13.1_http2_hpack.patch) by [Cloudflare](https://github.com/cloudflare/sslconfig)

## Information

- [Test Page - (TLS 1.3 draft 23, 26, 28)](https://ssl.hakase.io/)
- [SSL Test Result - testssl.sh](https://ssl.hakase.io/ssltest/hakase.io.html)
- [SSL Test Result - dev.ssllabs.com](https://dev.ssllabs.com/ssltest/analyze.html?d=hakase.io)
- **If you link site to a browser that supports draft 23 or 26 or 28, you'll see a TLS 1.3 message.**

**Support TLS 1.3 draft 28 browsers - _Chrome Canary, Firefox Nightly_**

[Compatible OpenSSL-1.1.1-pre8-dev (OpenSSL, 22330 commits)](https://github.com/openssl/openssl/tree/55fc247a699be33153f27c06d304e6e60eeff980)

## Patch files

You can find the _OpenSSL 1.1.0h_ patch is [here.](https://gitlab.com/buik/openssl/blob/openssl-patch/openssl-1.1/OpenSSL1.1h-equal-preference-cipher-groups.patch)

Here is the basic patch content.
- Support TLS 1.3 draft 23 + 26 + 28 (Not support pre2)
    - Server: draft 23 + 26 + 28
    - Client: draft 23 + 26 + 27 + 28
- BoringSSL's Equal Preference Patch
- Weak 3DES and not using ECDHE ciphers is not used in TLSv1.1 or later.

| Patch file name | Patch list |
| :--- | :--- |
| openssl-equal-pre2.patch | **_Not support_** draft **26, 28**. |
| openssl-equal-pre7.patch<br />openssl-equal-pre8.patch | TLS 1.3 cipher settings **_can not_** be changed on _nginx_. |
| openssl-equal-pre7_ciphers.patch<br />openssl-equal-pre8_ciphers.patch | TLS 1.3 cipher settings **_can_** be changed on _nginx_. |

**The "_ciphers" patch file is a temporary change to the TLS 1.3 configuration.**

Example of setting TLS 1.3 cipher in nginx (pre7 or higher):
- ex 1. TLS13+AESGCM+AES128:TLS13+AESGCM+AES256:TLS13+CHACHA20
- ex 2. TLS_AES_128_GCM_SHA256:TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256
- ex 3. TLS13+AESGCM+AES128:EECDH+AES128 (TLS 1.3 + TLS 1.2 ciphers)

## Not OpenSSL patch files

| Patch file name | Patch list |
| :--- | :--- |
| nginx_hpack_push.patch | _Patch both_ the HPACK patch and the **PUSH ERROR**. |
| nginx_hpack_push_fix.patch | _Patch only_ the **PUSH ERROR** of the hpack patch. (If the HPACK patch has already been completed) |

## nginx Configuration

### HPACK Patch

Add configure option : ``--with-http_v2_hpack_enc``

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

### OpenSSL-1.1.1-pre7, pre8 ciphers (draft 23, 26, 28)
```
[EECDH+ECDSA+AESGCM+AES128|EECDH+ECDSA+CHACHA20]:EECDH+ECDSA+AESGCM+AES256:EECDH+ECDSA+AES128+SHA:EECDH+ECDSA+AES256+SHA:[EECDH+aRSA+AESGCM+AES128|EECDH+aRSA+CHACHA20]:EECDH+aRSA+AESGCM+AES256:EECDH+aRSA+AES128+SHA:EECDH+aRSA+AES256+SHA:RSA+AES128+SHA:RSA+AES256+SHA:RSA+3DES
```

### OpenSSL-1.1.1-pre7_ciphers, pre8_ciphers ciphers (draft 23, 26, 28)
```
[TLS13+AESGCM+AES128|TLS13+AESGCM+AES256|TLS13+CHACHA20]:[EECDH+ECDSA+AESGCM+AES128|EECDH+ECDSA+CHACHA20]:EECDH+ECDSA+AESGCM+AES256:EECDH+ECDSA+AES128+SHA:EECDH+ECDSA+AES256+SHA:[EECDH+aRSA+AESGCM+AES128|EECDH+aRSA+CHACHA20]:EECDH+aRSA+AESGCM+AES256:EECDH+aRSA+AES128+SHA:EECDH+aRSA+AES256+SHA:RSA+AES128+SHA:RSA+AES256+SHA:RSA+3DES
```
