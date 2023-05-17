multi-tpm2-totp
---------------

Attest the trustworthiness of a device against a human using multiple
time-based one-time passwords (OTP) at boot.

## Configuration

Currently only mkinitcpio is supported. To enable it, add `multi-tpm2-totp`
to the `HOOKS` in `/etc/mkinitcpio.conf`.

## Add totp key

To add multiple OTPs, change the nvindex per OTP.

```bash
nvindex="0x018094B0"
tpm2-totp --nvindex "${nvindex}" --pcrs 7 init
echo "${nvindex}" > /etc/multi-tpm2-totp/LABEL
```

You can also group those in folders:
```bash
mkdir /etc/multi-tpm2-totp/main
nvindex="0x018094B0"
tpm2-totp --nvindex "${nvindex}" --pcrs 0,2,4,6,7 init
echo "${nvindex}" > /etc/multi-tpm2-totp/main/LABEL
```

Now rebuild your initramfs.

## Delete unneeded totp key

```bash
tpm2_nvundefine "$(cat /etc/multi-tpm2-totp/LABEL)"
rm /etc/multi-tpm2-totp/LABEL
```
