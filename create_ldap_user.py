import os
import sys

try:
    import ldap
    import ldif
except ImportError:
    print '''
    Error: You don't have python-ldap installed.
    '''
    sys.exit()

try:
    import hashlib
    from base64 import encodestring as encode
    from base64 import decodestring as decode
except ImportError:
    print '''
    Error: you don't have hashlib and base64 installed.
    '''

# LDAP Server Address
LDAP_URI = 'ldaps://ldap.example.com:636'

# LDAP base dn
BASEDN = 'ou=users,ou=ftp,dc=example,dc=com'

# Bind Credentials
BINDDN = 'cn=admin,dc=example,dc=com'
BINDPW = 'supersecretpassword'

def usage():
    print """
    CSV file format:
        WSFTP_ID, Description, Username, Home
    """


def remove_space_and_dot(string):
    """Remove leading and trailing dot and all whitespace."""
    return str(string).strip(' .').replace(' ','')


def salted_passwd(passwd):
    """ Creates a salted SHA1 in the accepted format of {SSHA}2MWJ1N8HoXctMBLDFp2P4SBC+QeX9ufz"""
    salt = os.urandom(4)
    h = hashlib.sha1(passwd)
    h.update(salt)
    return "{SSHA}" + encode(h.digest() + salt)[:-1]

def generate_uid(uid):
    """ Adds 5000 to the uid that is passwd in. """
    return int(uid) + 5000

def ldif_ftpuser(uid, description, username, home, passwd):
    print """
    LDIF DATA:
    Username: %s
    ID: %s
    Description: %s
    Home: %s
    Password: %s
    """ % ( username, uid, description, home, passwd )


    username = remove_space_and_dot(str(username))
    dn = "cn=%s,%s" % ( username, BASEDN )
    userPassword = salted_passwd(passwd)

    print """
    Username: %s
    Password Hash: %s
    """ %( username, userPassword)

    ldif = [
                ('objectClass',             ['PureFTPdUser', 'posixAccount', 'person']),
                ('sn',                      [username]),
                ('cn',                      [username]),
                ('userPassword',            [userPassword]),
                ('homeDirectory',           [home]),
                ('uidNumber',               [str(uid)]),
                ('gidNumber',               [str(uid)]),
                ('uid',                     [username]),
                ('description',             [description]),
                ('FTPStatus',               ['enabled']),
                ('FTPQuotaFiles',           ['0']),
                ('FTPQuotaMBytes',          ['0']),
                ('FTPDownloadBandwidth',    ['0']),
                ('FTPUploadBandwidth',      ['0']),
                ('FTPDownloadRatio',        ['0']),
                ('FTPUploadRatio',          ['0']),
           ]
    return dn, ldif

password_dict = {}
with open("ftp-users.pipe") as f:
    for line in f:
        (key,value) = line.split('|')
        password_dict[key] = value.strip()

if len(sys.argv) != 2 or len(sys.argv) > 2:
    print """Usage: $ python %s users.csv""" % ( sys.argv[0] )
    usage()
    sys.exit()
else:
    CSV = sys.argv[1]
    if not os.path.exists(CSV):
        print '''Error: files does not exists: ''', CSV
        sys.exit()

ldif_file = CSV + '.ldif'

# Remove existing ldif file
if os.path.exists(ldif_file):
    print '''Remove existing file: ''', ldif_file
    os.remove(ldif_file)

# Read user list.
userList = open(CSV, 'r')

# Convert to LDIF
for entry in userList.readlines():
    wsftp_id, uname, description, h  = entry.split('|')
    uid = generate_uid(wsftp_id)
    home = h.strip()
    username = uname.strip()
    passwd = password_dict[username].strip()
    if passwd == '':
        passwd = 'foo'

    print """
    Username: %s
    ID: %s
    Description: %s
    Home: %s
    Password: %s
    """ % ( username, uid, description, home, passwd )

    dn, data = ldif_ftpuser(uid, description, username, home, passwd)

    #write LDIF
    result = open(ldif_file, 'a')
    ldif_writer = ldif.LDIFWriter(result)
    ldif_writer.unparse(dn, data)

