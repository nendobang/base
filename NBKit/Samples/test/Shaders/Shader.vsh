//
//  Shader.vsh
//  test
//
//  Created by Kanaya Fumihiro on 11/01/31.
//  Copyright 2011 Skip co,.Ltd. All rights reserved.
//

attribute vec4 position;
attribute vec4 color;

varying vec4 colorVarying;

uniform float translate;

void main()
{
    gl_Position = position;
    gl_Position.y += sin(translate) / 2.0;

    colorVarying = color;
}
