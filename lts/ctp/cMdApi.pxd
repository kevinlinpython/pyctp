# -*- coding: utf-8 -*-

from cUserApiStruct cimport *
from libcpp cimport bool as cbool
from libc.string cimport const_char

cdef extern from "Python.h":
    ctypedef struct PyObject
    ctypedef struct PyMethodDef:
        const_char *ml_name
    object PyImport_ImportModule(const_char *name)
    object PyCFunction_NewEx(PyMethodDef *ml, PyObject *self, object module)
    object XGotAttr "PyObject_GetAttr"(object o, object attr_name)
    object XGetAttr "PyObject_GetAttrString"(object o, const_char *attr_name)
    object XCGetAttr "PyObject_GetAttrString"(PyObject *o, const_char *attr_name)
    int CSetAttr "PyObject_SetAttrString"(PyObject *o, const_char *attr_name, object v) except -1

cdef extern from "SecurityFtdcMdApi.h":
    cdef cppclass CMdApi "CSecurityFtdcMdApi":
        void Release() nogil
        void Init() nogil
        int Join() nogil
        const_char *GetTradingDay() nogil
        void RegisterFront(char *pszFrontAddress) nogil
        void RegisterSpi(CMdSpi *pSpi) nogil
        int SubscribeMarketData(char *ppInstrumentID[], int nCount, char *pExchageID) nogil
        int UnSubscribeMarketData(char *ppInstrumentID[], int nCount, char *pExchageID) nogil
        int ReqUserLogin(CReqUserLoginField *pReqUserLogin, int nRequestID) nogil
        int ReqUserLogout(CUserLogoutField *pUserLogout, int nRequestID) nogil

cdef extern from "SecurityFtdcMdApi.h" namespace "CSecurityFtdcMdApi":
    CMdApi *CreateFtdcMdApi(const_char *pszFlowPath) nogil except +

cdef extern from "CMdApi.h":
    cdef cppclass CMdSpi:
        CMdSpi(PyObject *obj)
        long tid
    void ReleaseMdApi(CMdApi *api, CMdSpi *spi)
    cdef PyObject *Xmod "__pyx_m"
    cdef PyMethodDef _init_method
    int CheckMemory(void *) except 0
    void XFixSysModules()
    object XStr(const_char *v)
    cdef const_char *S___name__, *S_ctypes, *S_addressof, *S_from_address, *S_DepthMarketData, *S_RspInfo, *S_RspUserLogin, *S_SpecificInstrument, *S_UserLogout
