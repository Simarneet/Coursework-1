<?xml version="1.0" encoding="UTF-8"?>
<!--
    Coursework 1
    Simarneet Singh Bindra, 140831607
    Akshat Khariwal, 140668922
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <!-- 
        Tokenize the input in an array name "myarray" and pass it as parameter to template "HeapSort"
    -->
    <xsl:template match="/">
        <xsl:call-template name="HeapSort">
            <xsl:with-param name="myarray" select="tokenize(.,' ')"></xsl:with-param>
        </xsl:call-template>
    </xsl:template>    
    
    <xsl:template name="HeapSort">
        <xsl:param name="myarray" as="xs:string*"/>
        <xsl:variable name="length" select="count($myarray)"/>
        <!--
            Creating heap by calling BuilHeap and passing myarray as parameter to the template.
            variable 'myarrayafterBuildHeap' contains the array representation of the heap.
        -->
        <xsl:variable name="myarrayafterBuildHeap" as="xs:string*">
            <xsl:call-template name="BuildHeap">
                <xsl:with-param name="myarray" as="xs:string*" select="$myarray"/>
            </xsl:call-template>
        </xsl:variable>
        <!--
            Sorting the array which represents the heap.
        -->
        <xsl:variable name="sortedmyarray" as="xs:string*">
            <xsl:call-template name="recursiveLoop">
                <xsl:with-param name="var" select="$length"/>
                <xsl:with-param name="myarray" as="xs:string*" select="$myarrayafterBuildHeap"/>
            </xsl:call-template>    
        </xsl:variable>
        
        <!-- Here we are ouputting our sorted myarray -->
        <listOfNumbers>
            <xsl:copy-of select="$sortedmyarray"/>    
        </listOfNumbers>
    </xsl:template>
    
    <!-- 
        Building the Heap.
    -->
    <xsl:template name="BuildHeap">
        <xsl:param as="xs:string*" name="myarray"/>
        <xsl:variable name="length" as="xs:integer">
            <xsl:value-of select="floor((count($myarray)) div 2) + 1"/>
        </xsl:variable>
        <xsl:variable name="heaped" as="xs:string*">
            <xsl:call-template name="recursiveHeapify">
                <xsl:with-param name="var" select="$length"/>
                <xsl:with-param name="myarray" as="xs:string*" select="$myarray"/>
            </xsl:call-template>    
        </xsl:variable>
        <xsl:copy-of select="$heaped"/>
    </xsl:template>    
    
    <!--
        Rearranges subtree of the heap starting from "index", so that it satisfies the
        basic rule of heap myarray[parent] >= myarray[child] 
    -->
    <xsl:template name="Heapify">
        <xsl:param name="myarray" as="xs:string*"/>
        <xsl:param name="length" as="xs:integer"/>
        <xsl:param name="index" as="xs:integer"/>
        <xsl:variable name="left" as="xs:integer" select="$index * 2"></xsl:variable>
        <xsl:variable name="right" as="xs:integer" select="$index * 2 + 1"/>
        <xsl:variable name="myarrayleft" as="xs:double" select="number($myarray[$left])"/>
        <xsl:variable name="myarrayright" as="xs:double" select="number($myarray[$right])"/>
        <xsl:variable name="myarrayindex" as="xs:double" select="number($myarray[$index])"/>
        <!--
            Assigning values to largest Temp according to condition to pass in heapify and swaping function
        -->
        <xsl:variable name="tempForLargest" as="xs:integer">
            <xsl:choose>
                <xsl:when test="$left &lt; $length and $myarrayindex &lt; $myarrayleft">
                    <xsl:copy-of select="$left"/>
                </xsl:when>
                <xsl:otherwise><xsl:copy-of select="$index"/></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="myarraytempForLargest" as="xs:double" select="number($myarray[$tempForLargest])"></xsl:variable>
        <xsl:variable name="tempForLargest2" as="xs:integer">
            <xsl:choose>
                <xsl:when test="$right &lt; $length and $myarraytempForLargest &lt; $myarrayright">
                    <xsl:copy-of select="$right"/>
                </xsl:when>
                <xsl:otherwise><xsl:copy-of select="$tempForLargest"/></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="mymyarray" as="xs:string*">
            <xsl:choose>
                <xsl:when test="$index != $tempForLargest2">
                    <xsl:variable name="swappedarray" as="xs:string*">
                        <xsl:call-template name="swaping">
                            <xsl:with-param name="myarray" as="xs:string*" select="$myarray"/>
                            <xsl:with-param name="i" select="$index"/>
                            <xsl:with-param name="j" select="$tempForLargest2"/>
                        </xsl:call-template>    
                    </xsl:variable>
                    <xsl:variable name="heapedarray" as="xs:string*">
                        <xsl:call-template name="Heapify">
                            <xsl:with-param name="myarray" as="xs:string*" select="$swappedarray"/>
                            <xsl:with-param name="length" select="$length"/>
                            <xsl:with-param name="index" select="$tempForLargest2"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:copy-of select="$heapedarray"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:copy-of select="$myarray"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:copy-of select="$mymyarray"/>
    </xsl:template>
    
    <!--
        To call heapify template for each index of current array.
    -->
    <xsl:template name="recursiveHeapify">
        <xsl:param name="var"/>
        <xsl:param name="myarray" as="xs:string*"/>
        <xsl:variable name="afterheapify" as="xs:string*">
            <xsl:call-template name="Heapify">
                <xsl:with-param name="myarray" select="$myarray"/>
                <xsl:with-param name="length" select="count($myarray) + 1"/>
                <xsl:with-param name="index" select="$var"/>
            </xsl:call-template>    
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$var &gt; 1">
                <xsl:call-template name="recursiveHeapify">
                    <xsl:with-param name="var" select="$var - 1"/>
                    <xsl:with-param name="myarray" select="$afterheapify"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="$afterheapify"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!--
        To call swaping and Heapify templates.
    -->
    <xsl:template name="recursiveLoop">
        <xsl:param name="var"/>
        <xsl:param name="myarray" as="xs:string*"/>
        <xsl:variable name="swappedarray" as="xs:string*" >
            <xsl:call-template name="swaping">
                <xsl:with-param name="myarray" as="xs:string*" select="$myarray"/>
                <xsl:with-param name="i" select="1"/>
                <xsl:with-param name="j" select="$var"/>
            </xsl:call-template>    
        </xsl:variable>
        <xsl:variable as="xs:string*" name="heapedarray">
            <xsl:call-template name="Heapify">
                <xsl:with-param name="myarray" as="xs:string*" select="$swappedarray"/>
                <xsl:with-param name="index" select="1"/>
                <xsl:with-param name="length" select="$var"/>
            </xsl:call-template>    
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$var &gt; 1">
                <xsl:call-template name="recursiveLoop">
                    <xsl:with-param name="var" select="$var - 1"/>
                    <xsl:with-param name="myarray" select="$heapedarray"/>
                </xsl:call-template>    
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="$heapedarray"/>        
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- swap the values at two given places of the given array.  -->
    <xsl:template name="swaping">
        <xsl:param name="myarray" as="xs:string*"/>
        <xsl:param name="i" as="xs:integer"/>
        <xsl:param name="j" as="xs:integer"/>
        <xsl:variable name="tempmyarray" as="xs:string*" select="$myarray"/>
        <xsl:variable name="swappedarray" as="xs:string*">
            <xsl:for-each select="$tempmyarray">
                <xsl:choose>
                    <xsl:when test="position() = $i"><xsl:copy-of select="$myarray[$j]"/></xsl:when>
                    <xsl:when test="position() = $j"><xsl:copy-of select="$myarray[$i]"/></xsl:when>
                    <xsl:otherwise><xsl:copy-of select="."></xsl:copy-of></xsl:otherwise>
                </xsl:choose> 
            </xsl:for-each>    
        </xsl:variable>
        <xsl:copy-of select="$swappedarray"/>
    </xsl:template>
</xsl:stylesheet>