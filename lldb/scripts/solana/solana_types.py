import re


class CBEType(object):
    PUBKEY = "Pubkey"
    ACCOUNT_INFO = "AccountInfo"

PUBKEY_REGEX = re.compile(r"^(cbe_program::pubkey::Pubkey)")
ACCOUNT_INFO_REGEX = re.compile(r"^(cbe_program::account_info::AccountInfo)")

CBE_TYPE_TO_REGEX = {
    CBEType.PUBKEY: PUBKEY_REGEX,
    CBEType.ACCOUNT_INFO: ACCOUNT_INFO_REGEX,
}

def classify_cbe_type(type):
    for ty, regex in CBE_TYPE_TO_REGEX.items():
        if regex.match(type.name):
            return ty
