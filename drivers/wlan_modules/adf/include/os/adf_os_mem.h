/*
 * Copyright (c) 2010, Atheros Communications Inc. 
 * All Rights Reserved.
 * 
 * Copyright (c) 2011 Qualcomm Atheros, Inc.
 * All Rights Reserved.
 * Qualcomm Atheros Confidential and Proprietary.
 * 
 */

/**
 * @ingroup adf_os_public
 * @file adf_os_mem.h
 * This file abstracts memory operations.
 */

#ifndef _ADF_OS_MEM_H
#define _ADF_OS_MEM_H

#include <adf_os_types.h>
#include <adf_os_mem_pvt.h>

/**
 * @brief Allocate a memory buffer. Note this call can block.
 *
 * @param[in] size    buffer size
 *
 * @return Buffer pointer or NULL if there's not enough memory.
 */
static inline void *
adf_os_mem_alloc(adf_os_device_t osdev, adf_os_size_t size)
{
    return __adf_os_mem_alloc(osdev, size);
}

void *
adf_os_mem_alloc_outline(adf_os_device_t osdev, adf_os_size_t size);

/**
 * @brief Free malloc'ed buffer
 *
 * @param[in] buf     buffer pointer allocated by @ref adf_os_mem_alloc
 */
static inline void
adf_os_mem_free(void *buf)
{
    __adf_os_mem_free(buf);
}

void
adf_os_mem_free_outline(void *buf);

static inline  void *
adf_os_mem_alloc_consistent(
    adf_os_device_t osdev, adf_os_size_t size, adf_os_dma_addr_t *paddr, adf_os_dma_context_t mctx)
{
    return __adf_os_mem_alloc_consistent(osdev, size, paddr, mctx);
}

static inline void
adf_os_mem_free_consistent(
    adf_os_device_t osdev,
    adf_os_size_t size,
    void *vaddr,
    adf_os_dma_addr_t paddr,
    adf_os_dma_context_t memctx)
{
    __adf_os_mem_free_consistent(osdev, size, vaddr, paddr, memctx);
}

/**
 * @brief Move a memory buffer. Overlapping regions are not allowed.
 *
 * @param[in] dst     destination address
 * @param[in] src     source address
 * @param[in] size    buffer size
 */
static inline __ahdecl void
adf_os_mem_copy(void *dst, const void *src, adf_os_size_t size)
{
    __adf_os_mem_copy(dst, src, size);
}

/**
 * @brief Does a non-destructive copy of memory buffer
 *
 * @param[in] dst     destination address
 * @param[in] src     source address
 * @param[in] size    buffer size
 */
static inline void 
adf_os_mem_move(void *dst, void *src, adf_os_size_t size)
{
	__adf_os_mem_move(dst,src,size);
}


/**
 * @brief Fill a memory buffer
 * 
 * @param[in] buf   buffer to be filled
 * @param[in] b     byte to fill
 * @param[in] size  buffer size
 */
static inline void
adf_os_mem_set(void *buf, a_uint8_t b, adf_os_size_t size)
{
    __adf_os_mem_set(buf, b, size);
}


/**
 * @brief Zero a memory buffer
 * 
 * @param[in] buf   buffer to be zeroed
 * @param[in] size  buffer size
 */
static inline __ahdecl void
adf_os_mem_zero(void *buf, adf_os_size_t size)
{
    __adf_os_mem_zero(buf, size);
}

void
adf_os_mem_zero_outline(void *buf, adf_os_size_t size);

/**
 * @brief Compare two memory buffers
 *
 * @param[in] buf1  first buffer
 * @param[in] buf2  second buffer
 * @param[in] size  buffer size
 *
 * @retval    0     equal
 * @retval    1     not equal
 */
static inline int
adf_os_mem_cmp(const void *buf1, const void *buf2, adf_os_size_t size)
{
    return __adf_os_mem_cmp(buf1, buf2, size);
}

/**
 * @brief Compare two strings
 *
 * @param[in] str1  First string
 * @param[in] str2  Second string
 *
 * @retval    0     equal
 * @retval    >0    not equal, if  str1  sorts lexicographically after str2
 * @retval    <0    not equal, if  str1  sorts lexicographically before str2
 */
static inline a_int32_t
adf_os_str_cmp(const char *str1, const char *str2)
{
    return __adf_os_str_cmp(str1, str2);
}
/**
 * @brief Copy from one string to another
 *
 * @param[in] dest  destination string
 * @param[in] src   source string
 * @param[in] bytes limit of num bytes to copy
 *
 * @return    0     returns the initial value of dest
 */
static inline char *
adf_os_str_ncopy(char *dest, const char *src, a_uint32_t bytes)
{
    return __adf_os_str_ncopy(dest, src, bytes);
}

/**
 * @brief Returns the length of a string
 *
 * @param[in] str   input string
 *
 * @return    length of string
 */
static inline a_int32_t
adf_os_str_len(const char *str)
{
    return (a_int32_t)__adf_os_str_len(str);
}


#endif
