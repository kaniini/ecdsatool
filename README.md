# ecdsatool

Copyright (c) 2013 William Pitcock <nenolod@dereferenced.org>.

This software is free, but copyrighted software.  See COPYING for terms
and conditions.

## what is this?

This tool creates and manipulates ECC NISTP256 keypairs, as used by the
proposed `ECDSA-NIST256P-CHALLENGE` IALv3.2 mechanism.

It is built ontop of a library called `libecdsaauth`, which provides
primitives for patching ECDSA challenge support into pre-existing clients
and daemons.

## how to use the tool?

First, lets create a keypair, and store it in `/home/nenolod/irc.pem`:

```
$ ecdsatool keygen /home/nenolod/irc.pem
A9T8WQPtyWlP0sEFQaugzQjWHH+hmoRIfFl7yaADaagb
```

This creates a new ECC NISTP256 keypair and stores it in `/home/nenolod/irc.pem`.
The value returned by ecdsatool is the public key, which you may register with
services.

Presently, to do that on Atheme, you would set it as a NickServ property.
A better interface for key enrollment will be added soon.  To do this, run
the following command on IRC:

`/msg nickserv set property pubkey A9T8WQPtyWlP0sEFQaugzQjWHH+hmoRIfFl7yaADaagb`

## recovering the public key from a private key?

Use the `pubkey` subcommand:

```
$ ecdsatool pubkey /home/nenolod/irc.pem
A9T8WQPtyWlP0sEFQaugzQjWHH+hmoRIfFl7yaADaagb
```

## interrogating information about keypairs?

Use the `keyinfo` subcommand:

```
$ ecdsatool keyinfo /home/nenolod/irc.pem
Information on /home/nenolod/irc.pem:
    Private-Key: (256 bit)
    priv:
        00:92:0c:69:ac:48:6b:ef:7e:96:69:0a:94:4b:df:
        97:34:00:a8:96:8e:da:05:ec:20:5f:33:36:26:08:
        b1:51:e5
    pub: 
        03:d4:fc:59:03:ed:c9:69:4f:d2:c1:05:41:ab:a0:
        cd:08:d6:1c:7f:a1:9a:84:48:7c:59:7b:c9:a0:03:
        69:a8:1b
    Field Type: prime-field
    Prime:
        00:ff:ff:ff:ff:00:00:00:01:00:00:00:00:00:00:
        00:00:00:00:00:00:ff:ff:ff:ff:ff:ff:ff:ff:ff:
        ff:ff:ff
    A:   
        00:ff:ff:ff:ff:00:00:00:01:00:00:00:00:00:00:
        00:00:00:00:00:00:ff:ff:ff:ff:ff:ff:ff:ff:ff:
        ff:ff:fc
    B:   
        5a:c6:35:d8:aa:3a:93:e7:b3:eb:bd:55:76:98:86:
        bc:65:1d:06:b0:cc:53:b0:f6:3b:ce:3c:3e:27:d2:
        60:4b
    Generator (compressed):
        03:6b:17:d1:f2:e1:2c:42:47:f8:bc:e6:e5:63:a4:
        40:f2:77:03:7d:81:2d:eb:33:a0:f4:a1:39:45:d8:
        98:c2:96
    Order: 
        00:ff:ff:ff:ff:00:00:00:00:ff:ff:ff:ff:ff:ff:
        ff:ff:bc:e6:fa:ad:a7:17:9e:84:f3:b9:ca:c2:fc:
        63:25:51
    Cofactor:  1 (0x1)
    Seed:
        c4:9d:36:08:86:e7:04:93:6a:66:78:e1:13:9d:26:
        b7:81:9f:7e:90
```

## signing challenges from scripts?

Use the `sign` subcommand.

```
$ ecdsatool sign /home/nenolod/irc.pem 'QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUE='
MEUCICNBUzxaMXcqyec7q0aZcHMa0HY9NELX869/8tjd58cFAiEA75FzpxmPOcotr0vc8ncEM79DoQRf/bOSoi1yK5X67J8=
```

## mechanism spec?

Similar to `EXTERNAL`:

1. Start authentication by sending `AUTHENTICATE ECDSA-NIST256P-CHALLENGE`.
2. Wait for an ACK from the IRC network.
3. Send the accountname encapsulated in base64.
4. Wait for the challenge message from the IRC network.
5. Sign the message and send it back, using `ecdsatool sign` or the library API.
6. If everything went to plan, authentication should be successful, and you'll
   be able to get on the network.


