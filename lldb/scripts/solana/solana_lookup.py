from cbe_providers import *
from cbe_types import CBEType, classify_cbe_type


def summary_lookup(valobj, dict):
    # type: (SBValue, dict) -> str
    """Returns the summary provider for the given value"""
    cbe_type = classify_cbe_type(valobj.GetType())
    if cbe_type == CBEType.PUBKEY:
        return PubkeySummaryProvider(valobj, dict)
    if cbe_type == CBEType.ACCOUNT_INFO:
        return AccountInfoSummaryProvider(valobj, dict)
