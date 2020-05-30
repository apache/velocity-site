<?xml version="1.0"?>
<!--
    Licensed to the Apache Software Foundation (ASF) under one or more
    contributor license agreements.  See the NOTICE file distributed with
    this work for additional information regarding copyright ownership.
    The ASF licenses this file to You under the Apache License, Version 2.0
    (the "License"); you may not use this file except in compliance with
    the License.  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:news="http://velocity.apache.org/NEWS/1.0.0"
    exclude-result-prefixes="news"
    version="1.0">
  <xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
  <xsl:template name="replace-nl">
    <xsl:param name="str"/>
    <xsl:if test="$str">
      <xsl:variable name="before" select="substring-before($str, '&#10;&#10;')"/>
      <xsl:variable name="after" select="substring-after($str, '&#10;&#10;')"/>
      <p>
        <xsl:choose>
          <xsl:when test="$before">
            <xsl:value-of select="normalize-space($before)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="normalize-space($str)"/>
          </xsl:otherwise>
        </xsl:choose>
      </p>
      <xsl:call-template name="replace-nl">
        <xsl:with-param name="str" select="$after"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
  <xsl:template match="//news:item">
    <div class="newsitem">
      <h3>
        <a name="{@id}">
          <xsl:value-of select="news:headline"/>
        </a>
      </h3>
      <div>
        <p>
          <b>
            <xsl:text>{{format_date(</xsl:text>
            <xsl:value-of select="news:date"/>
            <xsl:text>)}}</xsl:text>
          </b>
        </p>
        <xsl:call-template name="replace-nl">
          <xsl:with-param name="str" select="news:text"/>
        </xsl:call-template>
      </div>
    </div>      
  </xsl:template>
  <xsl:template match="text()"/>
</xsl:stylesheet>
